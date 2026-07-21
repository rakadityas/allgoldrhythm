import '../models/system_design.dart';

class SystemDesignData {
  static List<SystemDesignProblem> getProblems() => [
        _urlShortener,
        _rateLimiter,
        _distributedCache,
        _chatApplication,
        _newsFeed,
      ];

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

  static const _distributedCache = SystemDesignProblem(
    id: 'distributed_cache',
    title: 'Design a Distributed Key-Value Cache',
    difficulty: 'Hard',
    prompt: 'Design a distributed in-memory cache like Redis or Memcached: a horizontally-scalable '
        'key-value store that sits in front of a slower database and serves reads/writes with '
        'sub-millisecond latency.',
    functionalRequirements: [
      'put(key, value, ttl) — store a value, optionally with an expiration',
      'get(key) — retrieve a value by key',
      'delete(key) — remove a value',
      'Evict entries automatically when the cache is full (LRU) or when their TTL expires',
    ],
    nonFunctionalRequirements: [
      'Low latency — sub-millisecond gets/puts, since this sits on the hot path of every caller',
      'High availability — losing one cache node shouldn\'t take the whole cache down or spike load '
          'onto the database',
      'Scale — support millions of keys and hundreds of thousands of ops/sec by adding nodes '
          'horizontally, not just scaling one machine up',
      'Even load distribution — no single node should become a hot spot as nodes are added or removed',
    ],
    capacityEstimation: [
      'Assume 500K reads/sec and 50K writes/sec at peak — far beyond what one node\'s network/CPU '
          'can serve, so this has to be a cluster, not a single big machine',
      'Assume 100M hot keys × 1KB average value ≈ 100GB of data to keep in memory',
      'At ~64GB RAM usable per node, that\'s roughly 2-3 nodes for storage alone — round up for '
          'headroom and replication, e.g. 6-8 nodes',
      'Each node needs to survive losing a peer, so plan for at least 1 replica per shard '
          '(doubles the node count above)',
    ],
    apiDesign: [
      'GET /keys/{key} → 200 { value } or 404',
      'PUT /keys/{key} { value, ttlSeconds } → 200',
      'DELETE /keys/{key} → 200',
      '(Internally, clients usually talk a binary protocol, not REST, to keep per-op overhead low)',
    ],
    highLevelDesign: 'Keys are distributed across cache nodes using consistent hashing: each node owns a '
        'range of the hash ring, and a client (or a thin routing layer) hashes the key to find which node '
        'to talk to. Consistent hashing means adding or removing a node only reshuffles the keys near it on '
        'the ring, not the whole keyspace — critical for scaling the cluster without a cache-wide cold start.\n\n'
        'Each shard is itself a small primary-replica set: writes go to the primary and are asynchronously '
        'replicated, so losing a primary promotes a replica instead of losing that shard\'s data outright. '
        'On a cache miss, the caller falls back to the database and writes the result back into the cache '
        '(cache-aside), so the cache is always a rebuildable acceleration layer, never the source of truth. '
        'Eviction combines TTL expiry (checked lazily on access, plus a background sweep) with LRU once a '
        'node approaches its memory limit.',
    reference: ReferenceArchitecture(
      components: [
        ComponentType.client,
        ComponentType.apiServer,
        ComponentType.cache,
        ComponentType.database,
      ],
      connections: [
        (ComponentType.client, ComponentType.apiServer),
        (ComponentType.apiServer, ComponentType.cache),
        (ComponentType.apiServer, ComponentType.database),
      ],
    ),
  );

  static const _chatApplication = SystemDesignProblem(
    id: 'chat_application',
    title: 'Design a Chat Application',
    difficulty: 'Hard',
    prompt: 'Design a one-on-one and group messaging app like WhatsApp or Slack: users send messages that '
        'are delivered to online recipients in real time, and queued for delivery when recipients are offline.',
    functionalRequirements: [
      'Send a message to a specific user or group and have it delivered in real time if they\'re online',
      'Store message history so it\'s available when a user opens a conversation later',
      'Deliver queued messages when an offline user reconnects',
      '(Optional) Delivery/read receipts and typing indicators',
    ],
    nonFunctionalRequirements: [
      'Low latency — messages should arrive in well under a second for online recipients',
      'Durability — a message the server acknowledged must never be lost, even if a node crashes '
          'right after',
      'Ordering — messages within a single conversation should arrive in the order they were sent',
      'Scale — support millions of concurrent connections, most of them idle most of the time',
    ],
    capacityEstimation: [
      'Assume 50M daily active users, each averaging 40 messages/day → 2B messages/day ≈ 23K writes/sec '
          'average (plan for several times that at peak)',
      'Assume 10M of those users are concurrently connected at peak — each needs a long-lived '
          'connection held open somewhere',
      'At roughly 10-50K concurrent connections per WebSocket server (typical for a well-tuned event '
          'loop), that\'s on the order of hundreds of WebSocket server instances',
      'At ~200 bytes/message stored, 2B messages/day ≈ 400GB/day of message history — needs a database '
          'built for high write throughput and easy time-based partitioning',
    ],
    apiDesign: [
      'WebSocket: client connects and authenticates once, then sends { type: "message", to, body } and '
          'receives { type: "message", from, body, timestamp } pushed from the server',
      'POST /conversations/{id}/messages — fallback for clients not currently connected (e.g. via push '
          'notification tap) → 202 Accepted',
      'GET /conversations/{id}/messages?before={cursor} → paginated message history',
    ],
    highLevelDesign: 'Each client holds a persistent WebSocket connection to one of many WebSocket server '
        'instances behind a load balancer. Because a sender and recipient can land on different server '
        'instances, servers don\'t deliver messages directly to each other — a message is first written to '
        'a durable message queue keyed by conversation/recipient, which fans it out to whichever server '
        'instance currently holds that recipient\'s connection (tracked in a shared session-registry cache). '
        'This decouples "a message was accepted" from "a message was delivered", which is what makes '
        'offline delivery and ordering possible: if the recipient isn\'t connected anywhere, the message '
        'simply waits in the queue/database until they reconnect and pull it.\n\n'
        'Every message is also durably written to the database (partitioned by conversation) before being '
        'considered sent, so a crash between "queued" and "delivered" never loses data — the client can '
        'always re-fetch history. The database is the source of truth; the queue and in-memory session '
        'registry only exist to make delivery fast for the common case of both users being online.',
    reference: ReferenceArchitecture(
      components: [
        ComponentType.client,
        ComponentType.loadBalancer,
        ComponentType.webSocketServer,
        ComponentType.messageQueue,
        ComponentType.cache,
        ComponentType.database,
      ],
      connections: [
        (ComponentType.client, ComponentType.loadBalancer),
        (ComponentType.loadBalancer, ComponentType.webSocketServer),
        (ComponentType.webSocketServer, ComponentType.messageQueue),
        (ComponentType.webSocketServer, ComponentType.cache),
        (ComponentType.messageQueue, ComponentType.database),
      ],
    ),
  );

  static const _newsFeed = SystemDesignProblem(
    id: 'news_feed',
    title: 'Design a News Feed',
    difficulty: 'Hard',
    prompt: 'Design a social media news feed like Instagram or Twitter\'s home timeline: users follow other '
        'users, and see a reverse-chronological (or ranked) feed of posts from everyone they follow.',
    functionalRequirements: [
      'A user can create a post (text/image)',
      'A user can follow other users',
      'A user can load their feed: posts from everyone they follow, most recent first',
      '(Optional) Rank the feed instead of pure reverse-chronological order',
    ],
    nonFunctionalRequirements: [
      'Low latency — opening the app and loading the feed should feel instant',
      'High availability — the feed should keep working (even if slightly stale) during partial outages, '
          'rather than showing an error',
      'Scale — support users with very large follower counts (celebrities with 50M+ followers) without '
          'that one user\'s posts overwhelming the system',
      'Eventual consistency is acceptable — a new post doesn\'t need to appear in every follower\'s feed '
          'within milliseconds',
    ],
    capacityEstimation: [
      'Assume 200M daily active users, each loading their feed ~10 times/day → 2B feed reads/day '
          '≈ 23K reads/sec average',
      'Assume 200M users post an average of 0.5 posts/day → 100M posts/day ≈ 1.2K writes/sec average',
      'Read:write ratio is roughly 20:1 — feed loading vastly outweighs posting, so the design should '
          'optimize reads even at some cost to write complexity',
      'A celebrity with 50M followers would require 50M individual feed-list updates per post under a '
          'naive "fan out on write" approach — this is the bottleneck the design has to specifically handle',
    ],
    apiDesign: [
      'POST /posts { body, mediaUrl } → 201 { postId }',
      'POST /follows/{userId} → 200',
      'GET /feed?cursor={cursor} → paginated list of posts, most recent first',
    ],
    highLevelDesign: 'Two strategies, used together: fan-out-on-write for most users, fan-out-on-read for '
        'users with huge follower counts. When a normal user posts, a background worker (triggered via a '
        'message queue) pushes that post\'s ID into a precomputed "feed" list (cache) for each of their '
        'followers — so loading a feed later is just one fast cache read of an already-assembled list. This '
        'keeps reads cheap, which matters given the 20:1 read:write ratio.\n\n'
        'For celebrity accounts (followers above some threshold), fan-out-on-write is skipped entirely — '
        'writing to 50M feed lists per post would be far too slow and expensive. Instead, their posts are '
        'left in the database (or a dedicated hot-post cache) and merged into a follower\'s feed at read '
        'time, alongside their precomputed list. This hybrid is the standard answer to the "celebrity '
        'problem" and is the single most important trade-off in this design.\n\n'
        'Media (images/video) is stored in object storage and served through a CDN, not through the API '
        'servers, since serving large binary blobs from the same fleet handling feed logic would waste '
        'their capacity on the wrong kind of work.',
    reference: ReferenceArchitecture(
      components: [
        ComponentType.client,
        ComponentType.loadBalancer,
        ComponentType.apiServer,
        ComponentType.messageQueue,
        ComponentType.cache,
        ComponentType.database,
        ComponentType.objectStorage,
        ComponentType.cdn,
      ],
      connections: [
        (ComponentType.client, ComponentType.loadBalancer),
        (ComponentType.loadBalancer, ComponentType.apiServer),
        (ComponentType.apiServer, ComponentType.messageQueue),
        (ComponentType.messageQueue, ComponentType.cache),
        (ComponentType.apiServer, ComponentType.database),
        (ComponentType.apiServer, ComponentType.objectStorage),
        (ComponentType.client, ComponentType.cdn),
      ],
    ),
  );
}
