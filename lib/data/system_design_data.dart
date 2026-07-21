import '../models/system_design.dart';

class SystemDesignData {
  static List<SystemDesignProblem> getProblems() => [
        _urlShortener,
        _rateLimiter,
        _distributedCache,
        _chatApplication,
        _newsFeed,
        _notificationSystem,
        _webCrawler,
        _ticketBooking,
        _topKLeaderboard,
        _fileStorage,
        _videoPlatform,
      ];

  static const _urlShortener = SystemDesignProblem(
    id: 'url_shortener',
    title: 'Design a URL Shortener',
    difficulty: Difficulty.easy,
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
    difficulty: Difficulty.medium,
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
    difficulty: Difficulty.hard,
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
    difficulty: Difficulty.hard,
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
    difficulty: Difficulty.hard,
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

  static const _notificationSystem = SystemDesignProblem(
    id: 'notification_system',
    title: 'Design a Notification System',
    difficulty: Difficulty.medium,
    prompt: 'Design a service that lets other internal systems send notifications to users across '
        'multiple channels (push, email, SMS), reliably and without blocking the caller.',
    functionalRequirements: [
      'Internal services can request "send notification X to user Y" over a simple API',
      'Deliver via the user\'s registered channels: mobile push, email, and/or SMS',
      'Respect user preferences and opt-outs per notification type',
      '(Optional) Deduplicate, so a user never receives the same notification twice',
    ],
    nonFunctionalRequirements: [
      'The calling service must not wait for delivery — accepting a notification must be fast and async',
      'At-least-once delivery — an accepted notification must eventually be delivered or explicitly dead-lettered',
      'Scale — absorb large bursts (e.g. a marketing campaign to 10M users) without overwhelming downstream providers',
      'Third-party providers (APNs, email/SMS gateways) fail and rate-limit — the design must retry and back off',
    ],
    capacityEstimation: [
      'Assume 50M notifications/day average ≈ 600/sec, but campaign bursts of 100K/sec — a queue must absorb the spike',
      'Provider throughput is the bottleneck: e.g. an SMS gateway capped at 1K msgs/sec means a 10M-user campaign drains over hours by design',
      'Notification payloads are small (~1KB); 50M/day ≈ 50GB/day of transient queue data plus a delivery-status record per send',
    ],
    apiDesign: [
      'POST /notifications { userId, type, channels?, payload } → 202 Accepted { notificationId }',
      'GET /notifications/{id}/status → { status: queued | delivered | failed_per_channel }',
      'PUT /users/{id}/preferences { channel opt-ins per notification type } → 200',
    ],
    highLevelDesign: 'The API server validates the request, checks user preferences and device tokens '
        '(cached, since they\'re read on every send), then drops one message per target channel onto a '
        'message queue and immediately returns 202. This is the core decoupling: the caller learns '
        '"accepted", never "delivered", so a slow SMS provider can\'t slow down the checkout flow that '
        'triggered the notification.\n\n'
        'Pools of channel-specific workers consume the queue and call the third-party providers (APNs/FCM '
        'for push, email and SMS gateways). Workers are where all the messy reliability logic lives: '
        'per-provider rate limiting, retries with exponential backoff, and after repeated failures moving '
        'the message to a dead-letter queue for inspection rather than retrying forever. Each attempt\'s '
        'outcome is written to the database, which powers the status API and deduplication (skip if this '
        'notificationId was already delivered on this channel).\n\n'
        'Because workers pull from the queue at their own pace, a 10M-recipient campaign simply makes the '
        'queue deep instead of making anything fall over — the queue converts a burst into a steady drain '
        'at whatever rate the providers allow.',
    reference: ReferenceArchitecture(
      components: [
        ComponentType.client,
        ComponentType.loadBalancer,
        ComponentType.apiServer,
        ComponentType.messageQueue,
        ComponentType.worker,
        ComponentType.cache,
        ComponentType.database,
      ],
      connections: [
        (ComponentType.client, ComponentType.loadBalancer),
        (ComponentType.loadBalancer, ComponentType.apiServer),
        (ComponentType.apiServer, ComponentType.cache),
        (ComponentType.apiServer, ComponentType.messageQueue),
        (ComponentType.messageQueue, ComponentType.worker),
        (ComponentType.worker, ComponentType.database),
      ],
    ),
  );

  static const _webCrawler = SystemDesignProblem(
    id: 'web_crawler',
    title: 'Design a Web Crawler',
    difficulty: Difficulty.medium,
    prompt: 'Design a crawler that starts from seed URLs and systematically downloads billions of web '
        'pages (e.g. to feed a search index), discovering new links as it goes.',
    functionalRequirements: [
      'Start from a set of seed URLs and download each page\'s content',
      'Extract links from downloaded pages and add unseen ones to the crawl frontier',
      'Store raw page content for downstream processing (e.g. indexing)',
      'Re-crawl pages periodically to pick up changes',
    ],
    nonFunctionalRequirements: [
      'Politeness — never hammer a single host; respect robots.txt and per-domain rate limits',
      'Scale — billions of URLs means the frontier and "seen" set can\'t fit on one machine',
      'Robustness — malformed HTML, dead links, redirect loops, and spider traps must not crash or stall the crawl',
      'Freshness vs coverage — prioritize which URLs to crawl next rather than pure FIFO',
    ],
    capacityEstimation: [
      'Target 1B pages/month ≈ 400 pages/sec sustained fetch rate',
      'At ~100KB average page size, 1B pages ≈ 100TB/month of raw content — object storage, not a database',
      'The "have I seen this URL?" check happens for every extracted link — tens of thousands of lookups/sec, needing an in-memory structure (hash set / Bloom filter), not DB queries',
      'A single fetcher spends most time waiting on network I/O, so hundreds of concurrent fetches per worker machine are practical',
    ],
    apiDesign: [
      'Internal: enqueue(url, priority) → adds to the crawl frontier',
      'Internal: fetch worker loop — dequeue URL → download → store content → extract links → enqueue unseen links',
      'GET /crawl-status/{domain} → pages crawled, last crawl time (operational visibility)',
    ],
    highLevelDesign: 'The heart of the crawler is the frontier: a message queue of URLs to crawl, '
        'organized so that each host\'s URLs drain at a polite rate (per-domain sub-queues with rate '
        'limits) and prioritized by importance and freshness rather than pure FIFO. Fetcher workers pull '
        'from the frontier, download the page, and hand the raw HTML to storage — there is no user-facing '
        'client in this system; workers and queues ARE the system.\n\n'
        'Downloaded content goes to object storage (billions of ~100KB blobs is exactly what it\'s for), '
        'while page metadata — URL, crawl time, content hash, status — goes to the database. After '
        'storing, the worker extracts links and checks each against the "seen" set — a cache-resident '
        'structure (hash set or Bloom filter) since checking billions of URLs via database queries would '
        'be far too slow. Unseen URLs are enqueued back into the frontier, closing the loop: the crawler '
        'feeds itself.\n\n'
        'Politeness and robustness live in the workers: respect robots.txt (cached per domain), cap '
        'per-host concurrency, detect redirect loops and spider traps via depth/URL-pattern limits, and '
        'use the content hash to skip storing duplicate pages reached from different URLs.',
    reference: ReferenceArchitecture(
      components: [
        ComponentType.messageQueue,
        ComponentType.worker,
        ComponentType.cache,
        ComponentType.database,
        ComponentType.objectStorage,
      ],
      connections: [
        (ComponentType.messageQueue, ComponentType.worker),
        (ComponentType.worker, ComponentType.cache),
        (ComponentType.worker, ComponentType.objectStorage),
        (ComponentType.worker, ComponentType.database),
        (ComponentType.worker, ComponentType.messageQueue),
      ],
    ),
  );

  static const _ticketBooking = SystemDesignProblem(
    id: 'ticket_booking',
    title: 'Design Ticketmaster',
    difficulty: Difficulty.hard,
    prompt: 'Design a ticket-booking system for live events: users browse events, view available seats, '
        'and book them — where every popular on-sale is a stampede of users fighting over the same seats.',
    functionalRequirements: [
      'Browse events and view the seat map with real-time availability',
      'Reserve specific seats: held for a short window (e.g. 10 minutes) while the user pays',
      'Confirm the booking on successful payment; release the hold on timeout or cancellation',
      'Never sell the same seat twice',
    ],
    nonFunctionalRequirements: [
      'Strong consistency on seat state — double-selling a seat is the one unforgivable failure',
      'Survive extreme contention — a popular on-sale means 100K+ users racing for a few thousand seats in seconds',
      'Browsing must stay fast and available even while booking is under heavy load',
      'Reservations must expire reliably — an abandoned checkout can\'t lock a seat forever',
    ],
    capacityEstimation: [
      'Steady state is tiny (a few bookings/sec); design for the on-sale spike: 100K concurrent users targeting one event',
      'A 20K-seat arena has only 20K sellable units — writes are inherently bounded; the flood is contention, not volume',
      'Seat-map reads dominate during an on-sale (everyone refreshing availability) — serve them from cache, slightly stale, keeping the database for actual booking attempts',
      'Booking records are small; even 100M tickets/year is trivial storage — the challenge is concurrency, not capacity',
    ],
    apiDesign: [
      'GET /events/{id}/seats → seat map with availability (cached, may be seconds stale)',
      'POST /events/{id}/reservations { seatIds } → 201 { reservationId, expiresAt } or 409 Conflict if any seat is taken',
      'POST /reservations/{id}/confirm { paymentToken } → 200 booked, or 402 on payment failure',
      'DELETE /reservations/{id} → 200, seats released',
    ],
    highLevelDesign: 'Seat state is the critical section. Each seat row in the database moves through '
        'AVAILABLE → HELD → BOOKED, and the transition must be atomic: reserve with a conditional update '
        '(UPDATE seats SET status = HELD, reservation_id = ? WHERE seat_id IN (...) AND status = '
        'AVAILABLE) — if it affects fewer rows than requested, someone else won the race and the whole '
        'reservation rolls back with a 409. This one database-enforced check is what makes double-selling '
        'impossible; everything else in the design exists to keep load away from it.\n\n'
        'Holds expire via a TTL: the reservation carries expiresAt, a background worker (fed by a delay '
        'queue or periodic sweep) releases seats whose hold lapsed without payment, and the confirm step '
        'only succeeds if the reservation is still live. Payment happens against a held seat, never an '
        'available one, so the slow external payment call sits safely outside the contention window.\n\n'
        'The read path is deliberately decoupled: the seat map everyone is refreshing is served from '
        'cache, updated on every state change and acceptably a few seconds stale — a user may still '
        'occasionally click a just-taken seat and get a clean 409. During extreme on-sales, a virtual '
        'waiting room (admit users from a queue in batches) caps how many users can even reach the '
        'reservation endpoint, converting a stampede into an orderly drain the database can survive.',
    reference: ReferenceArchitecture(
      components: [
        ComponentType.client,
        ComponentType.loadBalancer,
        ComponentType.apiServer,
        ComponentType.cache,
        ComponentType.database,
        ComponentType.messageQueue,
        ComponentType.worker,
      ],
      connections: [
        (ComponentType.client, ComponentType.loadBalancer),
        (ComponentType.loadBalancer, ComponentType.apiServer),
        (ComponentType.apiServer, ComponentType.cache),
        (ComponentType.apiServer, ComponentType.database),
        (ComponentType.apiServer, ComponentType.messageQueue),
        (ComponentType.messageQueue, ComponentType.worker),
        (ComponentType.worker, ComponentType.database),
      ],
    ),
  );

  static const _topKLeaderboard = SystemDesignProblem(
    id: 'top_k_leaderboard',
    title: 'Design a Top-K Leaderboard',
    difficulty: Difficulty.medium,
    prompt: 'Design a real-time leaderboard for a game or contest: millions of players submit scores, and '
        'anyone can instantly see the top 10 plus their own current rank.',
    functionalRequirements: [
      'Record a player\'s score whenever they finish a game',
      'Show the global top-10 (or top-K) list, updated in near real time',
      'Show any player their own rank and score',
      '(Optional) Periodic leaderboards — daily/weekly boards that reset',
    ],
    nonFunctionalRequirements: [
      'Low latency reads — the top-10 and "my rank" queries are hit constantly and must return in milliseconds',
      'Near-real-time updates — a new high score should be reflected within seconds, not minutes',
      'Scale — tens of millions of players, thousands of score writes per second at peak',
      'Ranking correctness under concurrent updates — two simultaneous score submissions must both be reflected',
    ],
    capacityEstimation: [
      'Assume 25M monthly players, 5M daily; each plays ~10 games/day → 50M score writes/day ≈ 600/sec average, several thousand at peak',
      'Reads dominate: every game-over screen shows the leaderboard → tens of thousands of reads/sec',
      'A sorted structure of 25M (playerId, score) entries at ~50 bytes each ≈ 1.25GB — fits comfortably in one in-memory sorted set',
      'A SQL "ORDER BY score DESC" over 25M rows per read is impossible at this rate — ranking must be a data structure, not a query',
    ],
    apiDesign: [
      'POST /scores { playerId, score } → 202 Accepted',
      'GET /leaderboard?limit=10 → [ { rank, playerId, score } ]',
      'GET /players/{id}/rank → { rank, score, percentile }',
    ],
    highLevelDesign: 'The core insight: ranking is exactly what a cache-resident sorted set (e.g. Redis '
        'ZSET) is built for. ZADD inserts/updates a player\'s score in O(log n); ZREVRANGE 0 9 returns the '
        'top-10 and ZREVRANK returns any player\'s exact rank — all in memory, all in microseconds. This '
        'single data-structure choice eliminates the "sort 25M rows per read" problem entirely, which is '
        'the central trade-off of this design.\n\n'
        'Score submissions flow through a queue to a worker rather than writing the sorted set directly '
        'from the API path: the worker applies business rules (only keep the player\'s best score, detect '
        'impossible/cheated scores), updates the sorted set, and persists the raw submission to the '
        'database. The database is the durable source of truth — if the cache node dies, the sorted set is '
        'rebuilt from it — while the sorted set is the serving layer. Periodic boards fall out naturally: '
        'key the sorted set by period (leaderboard:2026-07-21) and let old keys expire.\n\n'
        'The top-10 itself is requested so often that it\'s worth a second micro-cache: the API server '
        'memoizes the top-10 response for ~1 second, absorbing the read storm while staying visibly '
        'real-time.',
    reference: ReferenceArchitecture(
      components: [
        ComponentType.client,
        ComponentType.loadBalancer,
        ComponentType.apiServer,
        ComponentType.messageQueue,
        ComponentType.worker,
        ComponentType.cache,
        ComponentType.database,
      ],
      connections: [
        (ComponentType.client, ComponentType.loadBalancer),
        (ComponentType.loadBalancer, ComponentType.apiServer),
        (ComponentType.apiServer, ComponentType.cache),
        (ComponentType.apiServer, ComponentType.messageQueue),
        (ComponentType.messageQueue, ComponentType.worker),
        (ComponentType.worker, ComponentType.cache),
        (ComponentType.worker, ComponentType.database),
      ],
    ),
  );

  static const _fileStorage = SystemDesignProblem(
    id: 'file_storage',
    title: 'Design Dropbox',
    difficulty: Difficulty.hard,
    prompt: 'Design a cloud file-storage and sync service like Dropbox or Google Drive: users upload files '
        'from any device and every other device sees the change shortly after.',
    functionalRequirements: [
      'Upload and download files of arbitrary size from any device',
      'Sync: a change made on one device appears on the user\'s other devices automatically',
      'Share files/folders with other users',
      'File version history — restore a previous version',
    ],
    nonFunctionalRequirements: [
      'Durability above all — a stored file must essentially never be lost (11 nines is the standard target)',
      'Bandwidth efficiency — editing one paragraph of a 1GB file must not re-upload the whole gigabyte',
      'Sync latency — cross-device propagation within seconds, without clients hammering the server with polls',
      'Large-file resilience — a 4GB upload over flaky Wi-Fi must resume, not restart',
    ],
    capacityEstimation: [
      'Assume 100M users averaging 10GB stored → 1EB logical storage; deduplication (identical chunks across users) typically cuts stored bytes dramatically',
      'Chunking at 4MB: a 4GB file = 1,000 chunks; an edit touching one chunk re-uploads 4MB, not 4GB — this is why chunking is non-negotiable',
      'Metadata (file → chunk list, versions, sharing) is tiny compared to blob data but read constantly — a classic metadata/data split',
      'Assume 10M devices online concurrently, each needing a cheap way to learn "something changed" — a notification channel, not polling',
    ],
    apiDesign: [
      'POST /files { path, chunkHashes[] } → { fileId, missingChunks[] } — server says which chunks it already has (dedup)',
      'PUT chunks directly to object storage via pre-signed URLs (one per missing chunk, resumable per chunk)',
      'GET /files/{id} → metadata + pre-signed download URLs for its chunks',
      'WebSocket/long-poll: server pushes { event: "changed", fileId, version } to the user\'s other devices',
    ],
    highLevelDesign: 'The defining decision is the metadata/data split. File content is chunked '
        'client-side (~4MB, content-addressed by hash) and moves directly between the client and object '
        'storage via pre-signed URLs — the API servers never proxy file bytes, only authorize transfers. '
        'This keeps the expensive path (bulk bytes) on infrastructure built for it, and makes uploads '
        'resumable and dedupable for free: the client sends its chunk hashes first, and the server '
        'responds with only the chunks it doesn\'t already have.\n\n'
        'The metadata service owns the small-but-hot truth: which chunks compose each file version, '
        'folder structure, and sharing ACLs, stored in the database. A new upload commits a new version '
        'row pointing at its chunk list — version history is then just keeping old rows, and restoring a '
        'version is a metadata operation that moves no bytes at all.\n\n'
        'Sync is push, not poll. When a version commits, the metadata service emits a change event onto a '
        'queue; a notification service holding each online device\'s persistent connection (WebSocket '
        'servers, like a chat system\'s delivery path) pushes "file X changed" to the user\'s other '
        'devices, which then fetch the new metadata and download only missing chunks. Offline devices '
        'catch up on reconnect by asking for changes since their last-known version cursor.',
    reference: ReferenceArchitecture(
      components: [
        ComponentType.client,
        ComponentType.loadBalancer,
        ComponentType.apiServer,
        ComponentType.database,
        ComponentType.objectStorage,
        ComponentType.messageQueue,
        ComponentType.webSocketServer,
      ],
      connections: [
        (ComponentType.client, ComponentType.loadBalancer),
        (ComponentType.loadBalancer, ComponentType.apiServer),
        (ComponentType.apiServer, ComponentType.database),
        (ComponentType.client, ComponentType.objectStorage),
        (ComponentType.apiServer, ComponentType.messageQueue),
        (ComponentType.messageQueue, ComponentType.webSocketServer),
        (ComponentType.client, ComponentType.webSocketServer),
      ],
    ),
  );

  static const _videoPlatform = SystemDesignProblem(
    id: 'video_platform',
    title: 'Design YouTube',
    difficulty: Difficulty.hard,
    prompt: 'Design a video-sharing platform: creators upload videos of any size and quality, and viewers '
        'around the world stream them smoothly on any device and connection speed.',
    functionalRequirements: [
      'Upload a video with title/description; it becomes watchable after processing',
      'Stream playback that adapts to the viewer\'s bandwidth (no fixed single quality)',
      'Video metadata: views, listings, search by title',
      '(Optional) Thumbnails, captions, and processing-status notifications to the uploader',
    ],
    nonFunctionalRequirements: [
      'Smooth playback globally — startup in under a second, minimal buffering, from any region',
      'Upload-to-available latency of minutes is acceptable — transcoding is legitimately async work',
      'Massive read skew — a tiny fraction of videos serve the vast majority of views',
      'Durability of originals — the uploaded master file must never be lost, it\'s the source for all re-processing',
    ],
    capacityEstimation: [
      'Assume 500 hours of video uploaded per minute; at ~1GB per hour of raw upload that\'s ~8GB/sec of ingest — straight into object storage, never through app servers',
      'Each video is transcoded into ~5 resolutions × segments: processing is embarrassingly parallel and sized by a worker fleet, not the API tier',
      'Views dominate: assume 1B watch-hours/day; at ~1GB/hour that\'s ~10PB/day egress — >95% of it must come from CDN edge caches, or the economics collapse',
      'Metadata (title, views, segment manifests) is small and cacheable; the view-count write storm is batched, not written per view',
    ],
    apiDesign: [
      'POST /videos { title, description } → { videoId, presignedUploadUrl }',
      'Client PUTs the raw file to object storage via the pre-signed URL (multipart, resumable)',
      'GET /videos/{id} → metadata + manifest URL (HLS/DASH playlist of segment URLs at multiple bitrates)',
      'Playback: client GETs the manifest, then streams small segments from the CDN, switching bitrate as bandwidth changes',
    ],
    highLevelDesign: 'Upload and playback are two nearly independent systems joined by object storage. On '
        'upload, the client sends metadata to the API (which records it in the database) and pushes the '
        'raw bytes directly to object storage with a pre-signed URL. Completion drops a job onto a '
        'message queue, and a fleet of transcoding workers picks it up: each worker splits the video into '
        'small segments and encodes each segment at multiple bitrates (240p → 4K), writing the results '
        'back to object storage and marking the video ready in the database. The queue is what lets a '
        'viral upload spike simply deepen the backlog while the worker fleet autoscales through it.\n\n'
        'Playback is adaptive bitrate streaming: the client fetches a manifest (HLS/DASH) listing every '
        'segment at every quality, then pulls segments over plain HTTP — measuring its own bandwidth and '
        'switching quality segment-by-segment. Because segments are small, immutable, and identical for '
        'every viewer, they are perfectly cacheable: the CDN serves the overwhelming majority of bytes '
        'from edge locations near the viewer, and only cache misses ever reach object storage. The '
        'read-skew problem (a few hot videos, most cold) is thus absorbed by the cache hierarchy '
        'automatically.\n\n'
        'Metadata reads (titles, manifests, view counts) go API → cache → database, with view counts '
        'accumulated in the cache and flushed to the database in batches — nobody needs a per-view '
        'durable write, and the database would melt under one.',
    reference: ReferenceArchitecture(
      components: [
        ComponentType.client,
        ComponentType.loadBalancer,
        ComponentType.apiServer,
        ComponentType.cache,
        ComponentType.database,
        ComponentType.objectStorage,
        ComponentType.messageQueue,
        ComponentType.worker,
        ComponentType.cdn,
      ],
      connections: [
        (ComponentType.client, ComponentType.loadBalancer),
        (ComponentType.loadBalancer, ComponentType.apiServer),
        (ComponentType.apiServer, ComponentType.cache),
        (ComponentType.apiServer, ComponentType.database),
        (ComponentType.client, ComponentType.objectStorage),
        (ComponentType.apiServer, ComponentType.messageQueue),
        (ComponentType.messageQueue, ComponentType.worker),
        (ComponentType.worker, ComponentType.objectStorage),
        (ComponentType.client, ComponentType.cdn),
      ],
    ),
  );
}
