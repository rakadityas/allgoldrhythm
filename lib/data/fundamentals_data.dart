import '../models/fundamental_concept.dart';
import '../models/system_design.dart';

/// The theory backbone of the System Design section: the fundamentals that
/// show up underneath almost every case study (networking, APIs, databases,
/// caching, load balancing, scaling, consistency, async processing, rate
/// limiting, storage, security), independent of any specific interview
/// question. Grouped by category, same grouping style as the algorithm list.
class FundamentalsData {
  static List<FundamentalConcept> getConcepts() => [
        ..._networking,
        ..._apis,
        ..._loadBalancing,
        ..._caching,
        ..._databases,
        ..._scaling,
        ..._consistency,
        ..._asyncProcessing,
        ..._rateLimiting,
        ..._storage,
        ..._security,
        ..._search,
        ..._notifications,
        ..._geospatial,
      ];

  static const _networking = [
    FundamentalConcept(
      id: 'dns_request_routing',
      category: 'Networking',
      title: 'DNS & Request Routing',
      summary:
          'Before a client can talk to your system, it has to turn a hostname into an IP address. DNS '
          '(Domain Name System) is the internet\'s phonebook: it maps human-readable domains like '
          '"api.example.com" to the IP address of a load balancer or edge server. This lookup is cached '
          'aggressively (by the browser, OS, and ISP) so it only happens occasionally, not on every request.',
      keyPoints: [
        'DNS resolution happens once (then caches via TTL) — it is not on the hot path of every request',
        'DNS can itself do coarse load balancing/failover by returning different IPs (round-robin DNS, geo-routing to the nearest region)',
        'After DNS resolves an IP, the client opens a TCP connection to that IP — usually a load balancer, not an individual server',
      ],
      diagram: ReferenceArchitecture(
        components: [ComponentType.client, ComponentType.loadBalancer, ComponentType.apiServer],
        connections: [
          (ComponentType.client, ComponentType.loadBalancer),
          (ComponentType.loadBalancer, ComponentType.apiServer),
        ],
      ),
      diagramCaption: 'Client resolves a hostname via DNS, then connects to the load balancer it points at.',
    ),
    FundamentalConcept(
      id: 'tcp_vs_udp',
      category: 'Networking',
      title: 'TCP vs UDP',
      summary:
          'TCP and UDP are the two transport protocols nearly everything is built on. TCP is connection-'
          'oriented and guarantees ordered, reliable delivery (retransmitting lost packets) — the right '
          'default for APIs, web pages, and anything where correctness matters more than raw speed. UDP is '
          'connectionless and makes no delivery guarantees, but has far lower overhead — used where speed '
          'matters more than occasional loss, like video calls, live streaming, or DNS lookups.',
      keyPoints: [
        'TCP: handshake to open a connection, guaranteed ordered delivery, automatic retransmission — used by HTTP, databases, most APIs',
        'UDP: no handshake, no delivery guarantee, no retransmission — used by video/voice calls, live streaming, DNS, some multiplayer games',
        'In interviews: default to TCP/HTTP unless the requirement is real-time media or you explicitly need to trade reliability for latency',
      ],
    ),
    FundamentalConcept(
      id: 'websockets_long_polling',
      category: 'Networking',
      title: 'WebSockets & Long Polling',
      summary:
          'Regular HTTP is request-response: the client always initiates. When the server needs to push '
          'updates to the client (chat messages, live scores, notifications), you need something else. '
          'WebSockets upgrade a single TCP connection into a persistent, full-duplex channel — either side '
          'can send at any time, with very low overhead per message. Long polling is a simpler fallback: the '
          'client sends a request that the server holds open until it has data (or a timeout), then the '
          'client immediately re-requests.',
      keyPoints: [
        'WebSockets: one persistent connection, low per-message overhead, true server push — best for chat, live collaboration, gaming',
        'Long polling: plain HTTP requests held open by the server — simpler to build/scale behind existing infra, but higher overhead per update',
        'Server-Sent Events (SSE): a lighter one-way alternative to WebSockets when the server only needs to push, never receive, over that channel',
        'Holding many persistent connections open means your API servers need to be provisioned for high connection counts, not just high request throughput',
      ],
    ),
  ];

  static const _apis = [
    FundamentalConcept(
      id: 'rest_vs_graphql_vs_grpc',
      category: 'APIs',
      title: 'REST vs GraphQL vs gRPC',
      summary:
          'REST models a system as resources (/users/123, /orders/45) manipulated with standard HTTP verbs '
          '— simple, cacheable, and universally understood, but can mean multiple round trips or over-'
          'fetching. GraphQL lets the client specify exactly the shape of data it wants in a single request '
          '— great for flexible frontends with many different views over the same data, at the cost of '
          'harder caching and more complex server-side query resolution. gRPC uses compact binary '
          '(Protocol Buffers) messages over HTTP/2 with strongly typed contracts — very fast and efficient, '
          'the default choice for internal service-to-service calls rather than public-facing APIs.',
      keyPoints: [
        'REST: resource-oriented, plain HTTP, easy to cache with standard HTTP caching — the default for public APIs',
        'GraphQL: client-specified queries, one round trip for complex nested data — good for varied frontend needs, harder to cache',
        'gRPC: binary protocol, strongly typed, HTTP/2 multiplexing, low latency — the default for internal microservice-to-microservice calls',
        'In interviews, naming the right one for client-facing vs internal traffic (e.g. "REST from mobile client, gRPC between services") signals real tradeoff awareness',
      ],
    ),
    FundamentalConcept(
      id: 'idempotency',
      category: 'APIs',
      title: 'Idempotency',
      summary:
          'An operation is idempotent if performing it multiple times has the same effect as performing it '
          'once. This matters enormously in distributed systems because networks are unreliable: a client '
          'might not receive a response even though the server successfully processed the request, so it '
          'retries. If "charge the credit card" isn\'t idempotent, that retry double-charges the customer.',
      keyPoints: [
        'GET, PUT, DELETE are naturally idempotent by HTTP convention; POST is not',
        'Common pattern: client generates a unique idempotency key per logical operation; server stores '
            'which keys it has already processed and returns the cached result instead of redoing the work',
        'Idempotency is what makes "just retry on failure" a safe default instead of a data-corruption risk',
      ],
    ),
  ];

  static const _loadBalancing = [
    FundamentalConcept(
      id: 'load_balancer_layers',
      category: 'Load Balancing',
      title: 'Load Balancer Layers (L4 vs L7)',
      summary:
          'A load balancer distributes incoming traffic across multiple backend servers so no single server '
          'is overwhelmed, and so the system keeps working if one server goes down. Layer 4 (transport-'
          'layer) load balancers route based on IP/port only — very fast, protocol-agnostic, but blind to '
          'the actual request content. Layer 7 (application-layer) load balancers understand HTTP itself, so '
          'they can route based on URL path, headers, or cookies (e.g. sending /api/* to one fleet and '
          '/static/* to another) — more flexible, at the cost of a bit more processing overhead.',
      keyPoints: [
        'L4: routes on IP/port, protocol-agnostic, very fast — good default when you just need to spread load',
        'L7: routes on HTTP content (path, headers, cookies) — needed for path-based routing, A/B testing, or session affinity',
        'Health checks: the load balancer pings backends and stops routing to any that fail, which is how the system tolerates individual server failures',
        'Common algorithms: round robin (even rotation), least connections (send to the least-busy server), weighted (send more to bigger servers)',
      ],
      diagram: ReferenceArchitecture(
        components: [ComponentType.client, ComponentType.loadBalancer, ComponentType.apiServer],
        connections: [
          (ComponentType.client, ComponentType.loadBalancer),
          (ComponentType.loadBalancer, ComponentType.apiServer),
        ],
      ),
      diagramCaption: 'The load balancer sits between clients and a fleet of servers, spreading and health-checking traffic.',
    ),
  ];

  static const _caching = [
    FundamentalConcept(
      id: 'caching_strategies',
      category: 'Caching',
      title: 'Caching Strategies',
      summary:
          'A cache is a small, fast store (usually in-memory, like Redis) that sits in front of a slower '
          'source of truth (usually a database) to serve hot reads without hitting the database every time. '
          'Cache-aside (the most common pattern): the app checks the cache first; on a miss it reads the '
          'database and populates the cache. Write-through: every write goes to the cache and database '
          'together, keeping them always in sync at the cost of slower writes. Write-back: writes go to the '
          'cache immediately and are flushed to the database later, which is fast but risks losing data if '
          'the cache fails before the flush.',
      keyPoints: [
        'Cache-aside: app manages cache population on read miss — simplest, most common, cache can go stale until next read-miss or explicit invalidation',
        'Write-through: write to cache + database together — cache is never stale, but every write pays both costs',
        'Write-back (write-behind): write to cache, flush to database asynchronously — fastest writes, but a cache crash before flush loses data',
        'Eviction policies decide what gets dropped when the cache is full — LRU (least recently used) is the most common default',
        'Cache invalidation is famously one of the two hard problems in computer science — always have a plan for how stale entries get removed or expired (TTL is the simplest)',
      ],
      diagram: ReferenceArchitecture(
        components: [ComponentType.apiServer, ComponentType.cache, ComponentType.database],
        connections: [
          (ComponentType.apiServer, ComponentType.cache),
          (ComponentType.cache, ComponentType.database),
        ],
      ),
      diagramCaption: 'Cache-aside: the API server checks the cache before falling back to the database.',
    ),
    FundamentalConcept(
      id: 'cdn_edge_caching',
      category: 'Caching',
      title: 'CDN & Edge Caching',
      summary:
          'A CDN (Content Delivery Network) caches content in edge servers physically distributed around '
          'the world, close to end users. Instead of every request crossing the globe to your origin '
          'servers, static assets (images, video, JS/CSS bundles) and even some API responses are served '
          'from a nearby edge node — dramatically cutting latency and offloading traffic from your origin.',
      keyPoints: [
        'Best fit for content that\'s the same for every user and doesn\'t change often — static assets, images, video, public pages',
        'On a cache miss, the edge node fetches from the origin, serves it, and caches it for subsequent nearby requests',
        'Reduces both latency (physical distance to the user) and origin load (fewer requests reach your actual servers)',
        'Personalized or highly dynamic responses generally bypass the CDN and go straight to the origin',
      ],
      diagram: ReferenceArchitecture(
        components: [ComponentType.client, ComponentType.cdn, ComponentType.apiServer],
        connections: [
          (ComponentType.client, ComponentType.cdn),
          (ComponentType.cdn, ComponentType.apiServer),
        ],
      ),
      diagramCaption: 'The CDN serves cached content from an edge node near the client, falling back to the origin on a miss.',
    ),
  ];

  static const _databases = [
    FundamentalConcept(
      id: 'sql_vs_nosql',
      category: 'Databases',
      title: 'SQL vs NoSQL',
      summary:
          'SQL (relational) databases enforce a fixed schema, support complex joins across tables, and give '
          'strong ACID guarantees — a great default when data is structured and relationships between '
          'entities matter (orders, payments, users). NoSQL databases trade some of that structure for '
          'flexibility and horizontal scalability: document stores (like MongoDB) hold semi-structured JSON-'
          'like records, key-value stores (like DynamoDB or Redis) are extremely fast for simple lookups by '
          'key, and wide-column stores (like Cassandra) are built for very high write throughput at scale.',
      keyPoints: [
        'SQL: fixed schema, joins, strong consistency/ACID — best when relationships and correctness matter most',
        'Document stores: flexible schema, good for nested/varying data shapes (user profiles, content)',
        'Key-value stores: simplest model, extremely fast reads/writes by key — great for caching and session data',
        'Wide-column stores: optimized for massive write throughput and horizontal scale — good for time-series and event data',
        'Interview framing: pick based on access patterns and consistency needs first, not familiarity — "how will this data be queried?" drives the choice',
      ],
    ),
    FundamentalConcept(
      id: 'acid_vs_base',
      category: 'Databases',
      title: 'ACID vs BASE',
      summary:
          'ACID (Atomicity, Consistency, Isolation, Durability) describes the strong transactional '
          'guarantees traditional relational databases offer: a transaction either fully happens or fully '
          'doesn\'t, the database always moves between valid states, concurrent transactions don\'t '
          'interfere with each other, and committed data survives crashes. BASE (Basically Available, Soft '
          'state, Eventually consistent) is the looser model many distributed NoSQL systems embrace instead '
          '— prioritizing availability and partition tolerance over immediate consistency, on the bet that '
          'most reads can tolerate slightly stale data in exchange for the system staying up and fast.',
      keyPoints: [
        'ACID is what you want for money, inventory counts, anything where a half-applied write is unacceptable',
        'BASE is what large distributed systems often settle for in exchange for availability and scale (see: CAP theorem)',
        'This is a spectrum, not a binary — many systems mix both, e.g. ACID within a single shard, eventual consistency across shards/regions',
      ],
    ),
    FundamentalConcept(
      id: 'indexing',
      category: 'Databases',
      title: 'Indexing',
      summary:
          'A database index is an auxiliary data structure (usually a B-tree or hash table) built on one or '
          'more columns that lets the database find matching rows without scanning the entire table. '
          'Without an index, looking up a row by some column means checking every row (O(n)); with one, it\'s '
          'closer to O(log n). The tradeoff: every index speeds up reads on that column but slows down '
          'writes (the index must be updated too) and takes extra storage.',
      keyPoints: [
        'Index the columns your queries actually filter or sort on (especially WHERE clauses and JOIN keys), not every column',
        'Composite indexes (multiple columns) can serve queries that filter on several fields together, but column order in the index matters',
        'Over-indexing hurts write throughput — every INSERT/UPDATE has to update every affected index too',
        'In interviews, naming which fields you\'d index (and why) is a quick, concrete way to show query-pattern awareness',
      ],
    ),
    FundamentalConcept(
      id: 'replication',
      category: 'Databases',
      title: 'Replication',
      summary:
          'Replication keeps copies of the same data on multiple database nodes, for two reasons: '
          'availability (if one node dies, others still have the data) and read scalability (reads can be '
          'spread across replicas). The most common setup is leader-follower: all writes go to a single '
          'leader, which then propagates changes to follower replicas; reads can be served from either. '
          'Multi-leader and leaderless setups exist for higher write availability, at the cost of needing to '
          'resolve conflicting concurrent writes.',
      keyPoints: [
        'Leader-follower (primary-replica): single writer avoids write conflicts; followers scale out reads and provide failover targets',
        'Replication lag: followers can be milliseconds to seconds behind the leader — reads from a follower can return stale data',
        'Synchronous replication waits for followers to confirm before acknowledging a write (safer, slower); asynchronous doesn\'t wait (faster, riskier on leader failure)',
        'If the leader fails, a follower is promoted — this failover process is exactly what gives the system high availability',
      ],
    ),
    FundamentalConcept(
      id: 'sharding_partitioning',
      category: 'Databases',
      title: 'Sharding & Partitioning',
      summary:
          'A single database server has limits — eventually the data or the write throughput outgrows what '
          'one machine can hold or handle, no matter how much you scale it vertically. Sharding splits data '
          'across many database servers, each holding a subset (a "shard"), based on a shard key (e.g. '
          'user ID). This is how systems scale writes horizontally, not just reads.',
      keyPoints: [
        'Hash-based sharding: hash the shard key to pick a shard — spreads data evenly, but makes range queries across shards expensive',
        'Range-based sharding: shard by key ranges (e.g. user IDs 1-1M on shard A) — makes range queries easy, but risks uneven "hot" shards',
        'Consistent hashing minimizes how much data has to move when a shard is added or removed, compared to naive modulo hashing',
        'Cross-shard queries and transactions are the main cost of sharding — good shard-key choice is the single biggest design decision here',
      ],
      diagram: ReferenceArchitecture(
        components: [ComponentType.apiServer, ComponentType.database],
        connections: [(ComponentType.apiServer, ComponentType.database)],
      ),
      diagramCaption: 'Conceptually, the API server routes each request to the shard that owns its key range or hash.',
    ),
    FundamentalConcept(
      id: 'geo_replication',
      category: 'Databases',
      title: 'Geo-Replication & Multi-Region',
      summary:
          'Geo-replication copies data across geographically distributed regions, for two reasons: lower '
          'read latency for users far from your primary region, and disaster recovery if an entire region '
          'goes down. Active-passive setups keep all writes in one region, with others as read replicas or '
          'standby — simple and conflict-free, but writes from far-away users still pay a long round trip. '
          'Active-active setups accept writes in multiple regions independently — low write latency '
          'everywhere, but now conflicting concurrent writes across regions have to be resolved.',
      keyPoints: [
        'Active-passive: one region takes all writes, others replicate for reads/failover — simple, no write conflicts, but distant users pay a long round trip on every write',
        'Active-active: every region accepts writes — fast everywhere, but needs the same conflict-resolution tools as any eventually-consistent system (last-write-wins or CRDTs)',
        'Cross-region replication lag is measured in tens to hundreds of milliseconds — that\'s physics (speed of light over distance), not a bug, and it caps how "instant" cross-region consistency can ever be',
        'A common interview move: keep each user\'s/entity\'s source of truth pinned to one region (lower latency, simpler consistency, often required for data-residency compliance) and only replicate what genuinely needs to be global',
      ],
    ),
  ];

  static const _scaling = [
    FundamentalConcept(
      id: 'horizontal_vs_vertical_scaling',
      category: 'Scaling',
      title: 'Horizontal vs Vertical Scaling',
      summary:
          'Vertical scaling means making a single machine bigger — more CPU, RAM, faster disks. It\'s '
          'simple (no architecture changes needed) but has a hard ceiling (there\'s a biggest machine you '
          'can buy) and a single point of failure. Horizontal scaling means adding more machines and '
          'spreading load across them. It scales much further and survives individual machine failure, but '
          'requires the system to be designed for it — statelessness, load balancing, and data '
          'partitioning all become necessary.',
      keyPoints: [
        'Vertical scaling: simplest first step, but eventually hits a ceiling and is still a single point of failure',
        'Horizontal scaling: near-unlimited headroom and fault tolerance, but requires statelessness, load balancing, and often data partitioning',
        'Most real systems scale vertically first (cheap, no redesign) and horizontally once they outgrow a single machine',
      ],
    ),
    FundamentalConcept(
      id: 'stateless_services',
      category: 'Scaling',
      title: 'Stateless Services',
      summary:
          'A stateless service keeps no per-user session data in its own memory between requests — any '
          'server can handle any request, because nothing about "who the user is" or "what they were doing" '
          'lives only on one machine. This is what makes horizontal scaling and load balancing actually '
          'work: if request N and request N+1 for the same user can land on different servers (which they '
          'will, behind a load balancer), those servers can\'t rely on remembering anything locally.',
      keyPoints: [
        'Session state (login status, shopping cart, etc.) is moved to a shared store — a database, or a fast shared cache — instead of server memory',
        'Statelessness is what lets you add or remove servers freely without losing anyone\'s session',
        'The alternative, sticky sessions (always routing a user to the same server), works but reintroduces a single point of failure per user and complicates load balancing',
      ],
    ),
  ];

  static const _consistency = [
    FundamentalConcept(
      id: 'cap_theorem',
      category: 'Consistency & Availability',
      title: 'CAP Theorem',
      summary:
          'The CAP theorem says a distributed system can only guarantee two of three properties at once: '
          'Consistency (every read sees the latest write), Availability (every request gets a response), '
          'and Partition tolerance (the system keeps working even when network communication between nodes '
          'fails). Since network partitions are a fact of life in any real distributed system, partition '
          'tolerance isn\'t really optional — the real-world choice is between consistency and availability '
          'when a partition happens: CP systems refuse requests they can\'t guarantee are consistent; AP '
          'systems answer anyway, possibly with stale data.',
      keyPoints: [
        'P (partition tolerance) is effectively mandatory for any real distributed system — the real tradeoff is C vs A during a partition',
        'CP example: a system that returns an error rather than risk serving stale/conflicting data (e.g. a bank ledger)',
        'AP example: a system that keeps serving reads/writes with eventual reconciliation, favoring uptime (e.g. a social media feed, a shopping cart)',
        'In interviews: state which side of CAP your design leans on for a given data path, and justify it against the actual requirement — this is one of the highest-signal things you can say',
      ],
    ),
    FundamentalConcept(
      id: 'eventual_consistency_quorum',
      category: 'Consistency & Availability',
      title: 'Eventual Consistency & Quorum',
      summary:
          'Eventual consistency means that if no new writes come in, all replicas will *eventually* converge '
          'to the same value — but at any given instant, different replicas might disagree. Many AP systems '
          'use quorum-based reads/writes to tune this tradeoff without going fully strict or fully loose: '
          'with N replicas, a write is confirmed once W of them accept it, and a read is confirmed once R of '
          'them agree; choosing W + R > N guarantees every read overlaps with the most recent write, which '
          'gives you strong consistency without needing every single replica to respond.',
      keyPoints: [
        'Eventual consistency trades "always up to date" for "always available and fast", betting that brief staleness is tolerable',
        'Quorum reads/writes (W + R > N) let you dial in a specific consistency/availability/latency tradeoff instead of picking an extreme',
        'Conflict resolution still has to be decided somewhere — last-write-wins (simple, can silently lose data) or vector clocks/CRDTs (more complex, preserves more information)',
      ],
    ),
    FundamentalConcept(
      id: 'consensus_leader_election',
      category: 'Consistency & Availability',
      title: 'Consensus & Leader Election',
      summary:
          'Consensus algorithms let a cluster of nodes agree on a single value or decision even when some '
          'nodes fail or messages are delayed or lost. Raft (and Paxos before it) is the standard pattern: '
          'nodes elect a leader by majority vote; the leader sequences all writes and replicates them to '
          'followers, only committing a write once a majority of nodes acknowledge it. The same leader-'
          'election idea shows up anywhere a system needs exactly one active coordinator — promoting a '
          'database replica after a failure, or making sure a scheduled job doesn\'t run twice.',
      keyPoints: [
        'A majority ("quorum") of nodes must agree before anything is considered durable — this lets the system tolerate a minority of node failures without losing data or electing two conflicting leaders (split brain)',
        'Leader election isn\'t just for consensus protocols themselves — it\'s also how a standby database replica gets promoted after the primary fails, or how one instance among many identical workers gets picked to run a singleton task',
        'You rarely implement Raft or Paxos yourself in an interview — you name it as the mechanism underneath coordination tools you\'d actually reach for (ZooKeeper, etcd, Kafka\'s controller election)',
        'The cost of strong consensus is latency: every committed write needs a round trip to a majority of nodes, which is why it\'s reserved for decisions that truly need it (leader election, config, distributed locks) rather than every write in the system',
      ],
    ),
  ];

  static const _asyncProcessing = [
    FundamentalConcept(
      id: 'message_queues',
      category: 'Asynchronous Processing',
      title: 'Message Queues',
      summary:
          'A message queue decouples the service that produces work from the service that processes it. '
          'Instead of the API server doing slow work (sending an email, resizing an image, charging a card) '
          'inline and making the client wait, it drops a message on a queue and responds immediately; a '
          'separate worker consumes the queue and does the work asynchronously. This smooths out traffic '
          'spikes (the queue absorbs bursts the workers process at their own pace) and isolates failures '
          '(a slow or crashing worker doesn\'t take down the API).',
      keyPoints: [
        'Decouples producers from consumers in both time and failure domain — the API server doesn\'t need the worker to be up right now',
        'Naturally smooths bursty traffic: the queue buffers a spike while workers drain it at a steady rate',
        'Needs a delivery guarantee decision: at-least-once (possible duplicates, requires idempotent consumers) vs at-most-once (possible silent loss)',
        'Good fit for anything that doesn\'t need to block the user\'s response: notifications, thumbnail generation, analytics events, order fulfillment steps',
      ],
      diagram: ReferenceArchitecture(
        components: [ComponentType.apiServer, ComponentType.messageQueue, ComponentType.database],
        connections: [
          (ComponentType.apiServer, ComponentType.messageQueue),
          (ComponentType.messageQueue, ComponentType.database),
        ],
      ),
      diagramCaption: 'The API server enqueues work and responds immediately; a worker drains the queue asynchronously.',
    ),
    FundamentalConcept(
      id: 'pub_sub',
      category: 'Asynchronous Processing',
      title: 'Publish/Subscribe (Pub-Sub)',
      summary:
          'Pub-sub is a variant of async messaging where one event can fan out to many independent '
          'consumers, not just one. A publisher emits an event to a topic without knowing or caring who\'s '
          'listening; any number of subscribers can independently receive and react to it. This is the '
          'natural fit when one thing happening (e.g. "order placed") needs to trigger several unrelated '
          'reactions (send confirmation email, update inventory, notify analytics) without those reactions '
          'coupling to each other.',
      keyPoints: [
        'One event, many independent consumers — contrast with a plain queue, where each message is typically consumed by exactly one worker',
        'Publishers and subscribers don\'t know about each other, which keeps services loosely coupled and independently deployable',
        'Common building block for event-driven architectures, where services react to events rather than calling each other directly',
      ],
    ),
    FundamentalConcept(
      id: 'batch_vs_stream_processing',
      category: 'Asynchronous Processing',
      title: 'Batch vs Stream Processing',
      summary:
          'Batch processing operates on a large, bounded chunk of accumulated data on a schedule — a nightly '
          'ETL job, a daily billing run. It\'s simple to reason about and efficient for aggregate work, but '
          'results are only as fresh as the last run. Stream processing (Kafka, Flink, Kinesis) processes '
          'each event continuously as it arrives, enabling near-real-time features like live dashboards or '
          'fraud detection — at the cost of meaningfully more complex infrastructure, since events can '
          'arrive out of order or late and have to be grouped into time windows rather than assumed '
          'sequential.',
      keyPoints: [
        'Batch: process accumulated data on a schedule — simple, efficient for aggregates (daily reports, billing), but freshness is bounded by the run interval',
        'Stream: process each event as it arrives — near-real-time, but requires windowing (grouping events into time buckets) to handle out-of-order and late-arriving data correctly',
        'Lambda architecture: run both a fast-but-approximate streaming path and a slower, exact batch path over the same data, letting batch periodically correct what streaming already showed',
        'Default to batch unless the product genuinely needs sub-second freshness — streaming infrastructure is a real operational cost, not a free upgrade',
      ],
    ),
  ];

  static const _rateLimiting = [
    FundamentalConcept(
      id: 'rate_limiting_algorithms',
      category: 'Rate Limiting',
      title: 'Rate Limiting Algorithms',
      summary:
          'Rate limiting protects a system from being overwhelmed — by abusive clients, buggy retries, or '
          'just more legitimate traffic than it can handle — by capping how many requests a client can make '
          'in a given window. Token bucket: a bucket refills with tokens at a steady rate, and each request '
          'consumes one; it naturally allows short bursts up to the bucket size. Leaky bucket: requests '
          'queue up and are processed at a fixed steady rate, smoothing bursts out entirely. Sliding window '
          'counter: counts requests in a rolling time window, avoiding the edge-case bursts fixed windows '
          'allow right at the window boundary.',
      keyPoints: [
        'Token bucket: allows controlled bursts, simple to reason about — a very common default',
        'Leaky bucket: enforces a strictly steady output rate — good when downstream systems need smooth, predictable load',
        'Fixed window counter: simplest to implement, but allows up to 2x the limit right at a window boundary',
        'Sliding window: fixes the boundary-burst problem at the cost of a bit more bookkeeping',
        'The limiter\'s own counters need to live in a shared, fast store (see Caching) so the limit holds correctly across many API server instances',
      ],
      diagram: ReferenceArchitecture(
        components: [ComponentType.client, ComponentType.loadBalancer, ComponentType.apiServer, ComponentType.cache],
        connections: [
          (ComponentType.client, ComponentType.loadBalancer),
          (ComponentType.loadBalancer, ComponentType.apiServer),
          (ComponentType.apiServer, ComponentType.cache),
        ],
      ),
      diagramCaption: 'Each request checks/updates a shared counter in cache before the API server does any real work.',
    ),
  ];

  static const _storage = [
    FundamentalConcept(
      id: 'object_storage',
      category: 'Storage',
      title: 'Object Storage',
      summary:
          'Object storage (like S3) stores large, unstructured blobs — images, videos, backups, log files '
          '— as flat objects addressed by a key, rather than as rows in a database or files in a '
          'traditional filesystem. It\'s built for massive scale and durability rather than fast random '
          'access or partial updates: you typically write or read a whole object at a time. Databases store '
          'a *reference* (a URL or key) to the object, not the object\'s bytes itself — keeping large blobs '
          'out of the database keeps it fast and small.',
      keyPoints: [
        'Best fit for large binary content that\'s written once and read many times: images, videos, documents, backups',
        'Nearly infinite horizontal scalability and very high durability (data replicated across multiple locations)',
        'Store the object in object storage, store a reference/URL to it in the database — never put large blobs directly in a relational database',
        'Often paired with a CDN in front of it for frequently-accessed public objects',
      ],
      diagram: ReferenceArchitecture(
        components: [ComponentType.apiServer, ComponentType.objectStorage, ComponentType.database],
        connections: [
          (ComponentType.apiServer, ComponentType.objectStorage),
          (ComponentType.apiServer, ComponentType.database),
        ],
      ),
      diagramCaption: 'The blob itself lives in object storage; the database only stores a reference/URL to it.',
    ),
  ];

  static const _security = [
    FundamentalConcept(
      id: 'authn_authz',
      category: 'Security',
      title: 'Authentication vs Authorization',
      summary:
          'Authentication (AuthN) answers "who are you?" — verifying identity, typically via a password, '
          'OAuth login, or API key, resulting in some kind of token (like a JWT or session ID) that proves '
          'who the caller is on subsequent requests. Authorization (AuthZ) answers "what are you allowed to '
          'do?" — checking that identity against permissions for the specific action being attempted. '
          'They\'re easy to conflate but are separate concerns: you can be authenticated (logged in) and '
          'still be unauthorized to, say, delete someone else\'s account.',
      keyPoints: [
        'Session tokens: server keeps session state (in a shared cache/database) and issues an opaque ID the client presents each time',
        'JWTs: self-contained signed tokens holding identity/claims — no server-side lookup needed to validate, at the cost of harder immediate revocation',
        'Authorization checks belong on every protected endpoint, not just at login — "logged in" is not the same as "allowed to do this specific thing"',
        'TLS/HTTPS encrypts data in transit between client and server — table stakes for any system handling credentials or personal data',
      ],
    ),
  ];

  static const _search = [
    FundamentalConcept(
      id: 'search_full_text_indexing',
      category: 'Search',
      title: 'Search & Full-Text Indexing',
      summary:
          'A relational index speeds up exact-match and range queries on a column, but it can\'t efficiently '
          'answer "which documents contain this word" — that needs a different data structure. Search '
          'engines like Elasticsearch and Solr are built around an inverted index: a map from each term to '
          'the list of documents that contain it, turning free-text search into a fast lookup instead of a '
          'full scan. On top of that, relevance ranking (e.g. TF-IDF or BM25) scores matches by how well '
          'they fit the query, not just whether they match, which is what makes results feel "smart".',
      keyPoints: [
        'An inverted index maps each term to the documents containing it — the core data structure behind Elasticsearch, Solr, and most search engines',
        'Relevance ranking (TF-IDF, BM25) scores how well a document matches a query rather than just whether it matches, so the best results surface first',
        'The search index is a derived, read-optimized copy of the data, not the source of truth — it\'s kept in sync with the primary database asynchronously (change data capture or dual writes), so results can lag slightly behind the latest write',
        'Reach for a dedicated search index specifically when the requirement is free-text, fuzzy, or ranked search — a normal database index already handles structured exact-match/range lookups',
      ],
    ),
  ];

  static const _notifications = [
    FundamentalConcept(
      id: 'push_notifications_fanout',
      category: 'Notifications',
      title: 'Push Notifications & Fan-out',
      summary:
          'Notifying users of an event (a new follower, a message, a price drop) at scale means fanning a '
          'single event out to potentially millions of recipients without doing that work synchronously in '
          'the request that triggered it — so it always goes through a queue and a worker, the same pattern '
          'as any async processing. There are two ways to structure the fan-out: fan-out-on-write '
          'precomputes and pushes the notification to every recipient at write time (fast reads, wasteful '
          'for a hugely popular event); fan-out-on-read computes "what should this user see" at read time '
          'instead (cheap writes regardless of audience size, more expensive per read).',
      keyPoints: [
        'Never generate notifications synchronously in the triggering request — enqueue the event and let a worker fan it out asynchronously',
        'Fan-out-on-write: push to every recipient\'s inbox at write time — fast to read later, but wasteful when one event has millions of recipients (a celebrity\'s post)',
        'Fan-out-on-read: store the event once, compute what each user sees at read time — cheap writes regardless of audience size, costlier per read',
        'Actual delivery to a device goes through a push provider (APNs for iOS, FCM for Android/web) that maintains the connection to the device — your backend hands off to the provider rather than holding that connection itself',
        'If the client already holds a live connection (a WebSocket/SSE, e.g. an open chat screen), push directly over that channel instead of round-tripping through a push provider',
      ],
      diagram: ReferenceArchitecture(
        components: [ComponentType.apiServer, ComponentType.messageQueue, ComponentType.client],
        connections: [
          (ComponentType.apiServer, ComponentType.messageQueue),
          (ComponentType.messageQueue, ComponentType.client),
        ],
      ),
      diagramCaption: 'The API server enqueues the event; a worker drains the queue and fans it out to recipients.',
    ),
  ];

  static const _geospatial = [
    FundamentalConcept(
      id: 'geospatial_indexing',
      category: 'Geospatial',
      title: 'Geospatial Indexing',
      summary:
          '"What\'s near me" — nearby drivers, restaurants, points of interest — can\'t be answered '
          'efficiently by a normal index, because proximity in 2D space isn\'t a value you can sort a plain '
          'B-tree index on. Geohashing encodes latitude/longitude into a single string where nearby points '
          'tend to share a prefix, turning "nearby" into a fast prefix/range query (what Redis\'s GEO '
          'commands use under the hood). Quadtrees and R-trees take a different approach, recursively '
          'dividing space into cells so a query only has to search cells near the target instead of scanning '
          'every point and computing distance.',
      keyPoints: [
        'A plain database index can\'t efficiently answer "what\'s within 2km of this point" — proximity search needs a structure built for spatial locality',
        'Geohashing encodes lat/lng into a string where nearby points share a prefix, turning proximity search into a prefix/range query — the basis of Redis GEO commands',
        'Quadtrees and R-trees recursively divide space into cells and only search nearby cells, avoiding a full scan-and-compute-distance over every point',
        'Uber\'s H3 (a hexagonal hierarchical grid) is a modern take on the same idea, and a common reference point in ride-sharing/delivery-style interview designs',
        'These indexes need updating whenever a point moves (a driver\'s live location) — the higher the update frequency, the more this favors simpler, cheaper-to-update structures over precise but expensive ones',
      ],
    ),
  ];
}
