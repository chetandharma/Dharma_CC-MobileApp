import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

// Map group email → role name
const GROUPS: Record<string, string> = {
  'admin@dharmanaturals.com': 'ADMIN',
  'cc-managers@dharmanaturals.com': 'CC_MANAGER',
  'area-managers@dharmanaturals.com': 'AREA_MANAGER',
};

// Priority order — if someone is in multiple groups, first match wins
const ROLE_PRIORITY = ['ADMIN', 'AREA_MANAGER', 'CC_MANAGER'];

Deno.serve(async (req) => {
  try {
    // Verify the caller is an authenticated Supabase user
    const authHeader = req.headers.get('Authorization');
    const googleAccessToken = req.headers.get('x-google-access-token');

    if (!authHeader || !googleAccessToken) {
      return respond(401, { error: 'Unauthorized' });
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_ANON_KEY')!,
      { global: { headers: { Authorization: authHeader } } },
    );

    const { data: { user }, error } = await supabase.auth.getUser();
    if (error || !user?.email) return respond(401, { error: 'Unauthorized' });

    // Use the user's own Google token to check their own group memberships
    const role = await resolveRole(user.email, googleAccessToken);

    if (!role) {
      return respond(403, { error: 'Access denied. You are not in an authorized group.' });
    }

    return respond(200, { role });
  } catch (err) {
    console.error(err);
    return respond(500, { error: 'Internal server error' });
  }
});

async function resolveRole(email: string, googleAccessToken: string): Promise<string | null> {
  // Cloud Identity Groups API — user can check their own memberships
  const query = `member_key_id == '${email}'`;
  const url = `https://cloudidentity.googleapis.com/v1/groups/-/memberships:searchDirectGroups?query=${encodeURIComponent(query)}&page_size=50`;

  const res = await fetch(url, {
    headers: { Authorization: `Bearer ${googleAccessToken}` },
  });

  if (!res.ok) {
    const err = await res.text();
    console.error('Cloud Identity API error:', err);
    return null;
  }

  const data = await res.json();
  const memberships: Array<{ groupKey?: { id?: string } }> = data.memberships ?? [];

  // Match against our groups in priority order
  for (const role of ROLE_PRIORITY) {
    const groupEmail = Object.keys(GROUPS).find((g) => GROUPS[g] === role)!;
    const found = memberships.some(
      (m) => m.groupKey?.id?.toLowerCase() === groupEmail.toLowerCase(),
    );
    if (found) return role;
  }

  return null;
}

function respond(status: number, body: object) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}
