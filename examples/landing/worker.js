// Minimal Worker for the example: records page events into D1, serves static assets for everything else.
export default {
  async fetch(req, env) {
    const url = new URL(req.url);
    if (url.pathname === "/e" && req.method === "POST") {
      const b = await req.json();
      await env.DB.prepare("insert into events (ts, site, ev) values (?, ?, ?)")
        .bind(Date.now(), env.SITE, String(b.ev).slice(0, 40))
        .run();
      return new Response(null, { status: 204 });
    }
    return env.ASSETS.fetch(req);
  },
};
