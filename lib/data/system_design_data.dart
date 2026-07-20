import '../models/system_design.dart';

class SystemDesignData {
  static List<SystemDesignProblem> getProblems() => [_urlShortener, _rateLimiter];

  static const _urlShortener = SystemDesignProblem(
    id: 'url_shortener',
    title: 'Design a URL Shortener',
    difficulty: 'Easy',
    prompt: 'Design a URL shortening service like bit.ly. Users submit a long URL and receive a short '
        'alias; visiting the short URL redirects to the original.',
    functionalRequirements: [
      'Given a long URL, generate a unique short URL',
      'Given a short URL, redirect the user to the original long URL',
      '(Optional) Let users pick a custom alias',
      '(Optional) Links expire after a set time',
    ],
    nonFunctionalRequirements: [
      'High availability — redirects must keep working even if some servers fail',
      'Low latency — redirection should feel instant (a few milliseconds)',
      'Uniqueness — no two long URLs should ever collide on the same short code',
      'Scale — the system should handle billions of stored URLs',
    ],
    capacityEstimation: [
      'Assume 100M new URLs created per month → about 40 writes/sec',
      'Assume a 100:1 read/write ratio (redirects vastly outnumber creations) → about 4,000 reads/sec',
      'Assume URLs are kept for 5 years: 100M × 12 × 5 = 6B records',
      'At roughly 500 bytes/record, that\'s 6B × 500B ≈ 3TB of storage — large, but manageable for a standard database with sharding',
    ],
    apiDesign: [
      'POST /shorten { longUrl } → { shortUrl }',
      'GET /{shortCode} → 302 redirect to the original long URL',
    ],
    highLevelDesign: 'Writes: the API server asks an ID Generator for a unique numeric ID (e.g. a '
        'Snowflake-style distributed counter), base62-encodes it into a short code (so it\'s compact and '
        'URL-safe), and stores the (shortCode → longUrl) mapping in the database. Encoding an already-unique '
        'ID sidesteps hash collisions entirely — no "check if taken, retry" loop needed.\n\n'
        'Reads: redirects are extremely read-heavy (100:1), so the API server checks a cache first for the '
        'shortCode → longUrl mapping. On a cache hit, it redirects immediately; on a miss, it falls back to '
        'the database and populates the cache for next time. This keeps the database load low even under '
        'heavy read traffic, and keeps redirects fast since hot links are served straight from memory.',
    reference: ReferenceArchitecture(
      components: [
        ComponentType.client,
        ComponentType.loadBalancer,
        ComponentType.apiServer,
        ComponentType.idGenerator,
        ComponentType.cache,
        ComponentType.database,
      ],
      connections: [
        (ComponentType.client, ComponentType.loadBalancer),
        (ComponentType.loadBalancer, ComponentType.apiServer),
        (ComponentType.apiServer, ComponentType.idGenerator),
        (ComponentType.apiServer, ComponentType.cache),
        (ComponentType.cache, ComponentType.database),
      ],
    ),
  );

  static const _rateLimiter = SystemDesignProblem(
    id: 'rate_limiter',
    title: 'Design a Rate Limiter',
    difficulty: 'Medium',
    prompt: 'Design a rate limiter that throttles how many requests a client can make to an API within '
        'a given time window, protecting backend services from being overwhelmed.',
    functionalRequirements: [
      'Limit the number of requests a client (by API key or user ID) can make per time window',
      'Reject requests that exceed the limit with a 429 Too Many Requests response',
      'Support different limits for different clients or endpoints',
    ],
    nonFunctionalRequirements: [
      'Low latency — the rate-limit check itself must not meaningfully slow down every request',
      'Accuracy under distributed load — limits must hold even with many API server instances running behind a load balancer',
      'High availability — the rate limiter itself shouldn\'t become a single point of failure',
    ],
    capacityEstimation: [
      'Assume 10,000 requests/sec system-wide need a rate-limit check',
      'Each check is a fast counter read+increment — an in-memory store like Redis handles 100K+ ops/sec, well within budget',
      'Counters only need to persist for the current window (e.g. 60 seconds) and can auto-expire (TTL), keeping memory usage small',
    ],
    apiDesign: [
      'Internal: allowRequest(clientId, endpoint) → boolean, checked before forwarding to the API server',
      'Response headers on every request: X-RateLimit-Remaining, X-RateLimit-Reset',
    ],
    highLevelDesign: 'Every request first hits a rate-limit check (e.g. inside the API server, or a small '
        'dedicated layer) that reads and increments a counter for that client in a shared cache, using an '
        'algorithm like token bucket or sliding window counter. If the client is under their limit, the '
        'request proceeds; otherwise it\'s rejected immediately with a 429, before ever reaching the '
        'expensive backend logic.\n\n'
        'The counter must live in a shared cache rather than each API server\'s own memory — with multiple '
        'servers behind a load balancer, per-server counters would each separately allow the client up to '
        'the limit, letting them exceed the intended total simply by getting routed to different servers.',
    reference: ReferenceArchitecture(
      components: [
        ComponentType.client,
        ComponentType.loadBalancer,
        ComponentType.apiServer,
        ComponentType.cache,
      ],
      connections: [
        (ComponentType.client, ComponentType.loadBalancer),
        (ComponentType.loadBalancer, ComponentType.apiServer),
        (ComponentType.apiServer, ComponentType.cache),
      ],
    ),
  );
}
