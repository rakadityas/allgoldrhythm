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
        ..._distributedCoordination,
        ..._dataStructuresForScale,
        ..._databaseInternals,
        ..._architecturePatterns,
        ..._communicationProtocols,
        ..._reliabilityResilience,
        ..._idsAndEstimation,
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
    FundamentalConcept(
      id: 'erasure_coding_vs_replication',
      category: 'Storage',
      title: 'Replication vs Erasure Coding',
      summary:
          'Both replication and erasure coding protect data against loss, but at very different storage '
          'costs. Replication photocopies the whole object multiple times (3 full copies is a common '
          'default) — simple and fast to read from any copy, but at 3x the raw storage cost. Erasure coding '
          'instead splits an object into data fragments plus extra parity fragments (e.g. 10 data + 4 parity '
          'fragments), and the object can be fully reconstructed from any subset that adds up to the original '
          'data-fragment count — tolerating multiple fragment losses at a fraction of replication\'s storage '
          'overhead, at the cost of more CPU work to reconstruct on read.',
      keyPoints: [
        'Replication: N full copies of the data — simple, fast reads from any copy, but N× storage overhead (commonly 3x)',
        'Erasure coding: split data into fragments plus parity fragments; the original is reconstructable from any large-enough subset — much lower storage overhead than full replication for the same fault tolerance',
        'Erasure coding trades storage cost for CPU cost: reconstructing lost fragments takes real compute, unlike simply reading an intact replica',
        'Object storage systems (S3-style) commonly use erasure coding for cold/archival data where storage cost dominates, and replication where read latency matters more',
      ],
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
    FundamentalConcept(
      id: 'oauth2_oidc_sso',
      category: 'Security',
      title: 'OAuth2, OIDC & SSO',
      summary:
          'OAuth2 is a delegation protocol: it lets a user grant an application limited access to their data '
          'on another service, without ever handing over their password. "Sign in with Google" is OAuth2 in '
          'action. OIDC (OpenID Connect) is a thin identity layer built on top of OAuth2 — it adds an ID '
          'token (a JWT describing who the user is) so OAuth2\'s delegation machinery can also answer "who is '
          'this person," not just "what can this app do." SSO (Single Sign-On) is the resulting product: log '
          'in once at a trusted identity provider, then access many apps without re-authenticating.',
      keyPoints: [
        'Authorization Code + PKCE: the standard flow for web/mobile apps — a code verifier/challenge pair prevents the authorization code from being intercepted and replayed',
        'Client Credentials flow: service-to-service auth with no user involved — the service authenticates with a client ID + secret and gets an access token directly',
        'Device Code flow: for devices without a browser (smart TVs, CLI tools) — the user approves on a separate device while the original polls for the token',
        'OIDC adds an ID token (JWT) on top of OAuth2\'s access token — OAuth2 alone says what an app can do, OIDC says who the user is',
      ],
    ),
    FundamentalConcept(
      id: 'jwt_and_sessions',
      category: 'Security',
      title: 'JWTs, Sessions & Token Revocation',
      summary:
          'Once a user authenticates, the server needs a way to recognize them on every subsequent request '
          'without asking for a password again. A session token is opaque and stateful: the server stores all '
          'the session data (in Redis or a database) and hands the client a random ID that means nothing on '
          'its own. A JWT is self-contained and stateless: it\'s a signed blob carrying the user\'s identity '
          'and claims directly, so any service can verify it without a database lookup — at the cost of being '
          'much harder to revoke instantly, since a JWT is valid until it expires unless something explicit '
          'checks a blocklist.',
      keyPoints: [
        'JWT claims: sub (subject), iat (issued-at), exp (expiry), jti (unique token ID), aud (audience) — never put secrets in the payload, it\'s base64-encoded, not encrypted',
        'Stateless (JWT): fast, no DB call to validate, but not instantly revocable. Stateful (session): a Redis lookup per request, but DEL session:{token} revokes it immediately',
        'Revoking a JWT early requires a jti blocklist (e.g. in Redis with a TTL matching the token\'s remaining lifetime) — checked after signature verification on every request',
        'Refresh token rotation: issue a new refresh token on every use and invalidate the old one; if an old (already-rotated) refresh token is ever reused, treat it as theft and revoke all tokens for that user',
      ],
    ),
    FundamentalConcept(
      id: 'mfa_and_passwordless',
      category: 'Security',
      title: 'Password Hashing, MFA & Passwordless Auth',
      summary:
          'Passwords should never be stored in plaintext, or even as a raw hash — a slow, memory-hard hashing '
          'function like Argon2id (or bcrypt as a fallback) combined with a unique per-user salt makes '
          'brute-forcing stolen password hashes impractical. On top of that, Multi-Factor Authentication (MFA) '
          'requires two or more of: something you know (password), something you have (a phone, a hardware '
          'key), or something you are (biometrics). Not all factors are equal — SMS OTP is the weakest, since '
          'SIM-swapping attacks can intercept it, while WebAuthn/FIDO2 (hardware keys, Face ID, fingerprint) '
          'is origin-bound and phishing-resistant, making it the strongest option available today.',
      keyPoints: [
        'Argon2id(password, per-user-salt, memory=64MB, iterations=3) is the current OWASP-recommended default; bcrypt(cost=12) is an acceptable fallback — never MD5, SHA1, or plain SHA256',
        'A salt is a random per-user value stored alongside the hash — it defeats rainbow tables and ensures identical passwords produce different hashes',
        'MFA strength ranking (weakest to strongest): SMS OTP (vulnerable to SIM swap) < TOTP app (Google Authenticator, RFC 6238) < WebAuthn/FIDO2 (hardware key or device biometric, phishing-resistant)',
        'Step-up authentication: re-authenticate or require an extra factor mid-session only when a sensitive action is triggered (e.g. "confirm with fingerprint to send over 10M IDR"), rather than forcing MFA on every request',
      ],
    ),
    FundamentalConcept(
      id: 'authorization_models',
      category: 'Security',
      title: 'Authorization Models: RBAC, ABAC & ReBAC',
      summary:
          'Once identity is established, a system still needs a model for deciding what that identity can '
          'do. RBAC (Role-Based Access Control) is the simplest and most common: roles are assigned to '
          'users, permissions are assigned to roles — coarse-grained, easy to reason about, and a good '
          'starting point. ABAC (Attribute-Based Access Control) checks rich conditions instead — who the '
          'user is, what the resource is, and the current context, e.g. "block if new_device AND amount > '
          '10M AND hour > 22:00." ReBAC (Relationship-Based Access Control), the Google Zanzibar model, '
          'derives permissions from a relationship graph — "user can view doc because they\'re a member of a '
          'group that has access to the folder containing it" — and fits naturally when permissions are '
          'graph-like: social graphs, document hierarchies, multi-tenant platforms.',
      keyPoints: [
        'RBAC: roles like [customer, merchant, ops-l1, finance-admin] checked in middleware or at the API gateway — simple, but coarse-grained',
        'ABAC: rules like "block if new_device AND amount > 10M AND hour > 22:00" — more flexible than RBAC, evaluated per request against attributes',
        'ReBAC: permissions derived from a relationship graph (Google Zanzibar / AuthZed / OpenFGA) — the natural fit for social graphs and nested folder/document permissions',
        'OPA (Open Policy Agent): a CNCF policy engine using the Rego language, runs as a sidecar, keeps authorization rules in version-controlled code that\'s testable and deployable independently of the app',
      ],
    ),
    FundamentalConcept(
      id: 'encryption_at_rest_transit',
      category: 'Security',
      title: 'Encryption at Rest & in Transit',
      summary:
          'Data needs protecting both while it moves and while it sits still. In transit, TLS 1.3 (or mTLS, '
          'where both client and server present certificates) encrypts traffic between services, using '
          'ephemeral Diffie-Hellman key exchange so that even a captured private key later can\'t decrypt '
          'past sessions (forward secrecy). At rest, AES-256-GCM is the standard for encrypting stored data, '
          'combined with envelope encryption: each record is encrypted with a Data Encryption Key (DEK), and '
          'the DEK itself is encrypted by a Master Encryption Key (MEK) that lives inside a KMS (AWS KMS, '
          'HashiCorp Vault) and never leaves it as plaintext. This means rotating the master key only means '
          're-encrypting the small DEKs, not the entire dataset.',
      keyPoints: [
        'TLS 1.3 negotiates a cipher suite, authenticates the server certificate, and establishes session keys before any data flows — with forward secrecy via ephemeral (EC)DHE by default',
        'mTLS (mutual TLS): both client and server present certificates, giving cryptographic identity to both sides — common for service-to-service auth in a service mesh',
        'Envelope encryption: data is encrypted with a DEK, and the DEK is encrypted by an MEK inside a KMS — key rotation then only means re-encrypting DEKs, not all the underlying data',
        'Field-level encryption: encrypt only specific sensitive columns (card numbers, SSNs) rather than the whole row, keeping IDs and metadata queryable',
      ],
    ),
    FundamentalConcept(
      id: 'secrets_management',
      category: 'Security',
      title: 'Secrets Management',
      summary:
          'API keys, database passwords, and signing keys are secrets, and hardcoding them in source code — '
          'or even committing them to Git at all — is one of the most common real-world breaches. A secrets '
          'manager (HashiCorp Vault, AWS Secrets Manager) centralizes storage, access control, and rotation. '
          'The strongest pattern is dynamic secrets: instead of a long-lived shared database password, Vault '
          'generates a fresh, unique credential per service instance with a short TTL, and auto-revokes it on '
          'expiry — so a leaked credential is only useful for a narrow window, and no service ever shares a '
          'password with another.',
      keyPoints: [
        'Never hardcode secrets in source, commit them to Git, or let them appear in CI logs or env var dumps — scan Git history with tools like truffleHog or gitleaks',
        'Dynamic secrets: Vault generates a fresh DB credential per service instance with a TTL, auto-revoked on expiry — no long-lived shared passwords',
        'Secret rotation: regularly and automatically change secrets with a grace-period overlap so rotation doesn\'t cause downtime',
        'A sidecar can fetch and renew secrets on behalf of the app, so the app just reads from a local file/env and never talks to the secrets manager\'s API directly',
      ],
    ),
    FundamentalConcept(
      id: 'api_security_owasp',
      category: 'Security',
      title: 'API Security & the OWASP Top 10',
      summary:
          'Most real-world API breaches trace back to a handful of well-known vulnerability classes, '
          'catalogued in the OWASP API Security Top 10. The most common by far is BOLA (Broken Object Level '
          'Authorization): accessing another user\'s resource just by guessing or changing an ID in the '
          'request, e.g. GET /transactions/txn_456 without checking that txn_456 actually belongs to the '
          'caller — the fix is always scoping the query with WHERE txn.user_id = auth.user_id, never trusting '
          'a path or body parameter for ownership. Other classic vectors include SQL injection (mitigated by '
          'parameterized queries, never string-concatenating user input), XSS (mitigated by a Content-'
          'Security-Policy header and escaping output), CSRF (mitigated by SameSite cookies and CSRF '
          'tokens), and SSRF (mitigated by blocking internal IP ranges like 169.254.169.254, the AWS metadata '
          'endpoint).',
      keyPoints: [
        'BOLA (#1 on the OWASP API list): always scope queries by the authenticated user (WHERE txn.user_id = auth.user_id), never trust a path/body ID alone for ownership',
        'SQL Injection: prevented by parameterized queries / prepared statements — never string-concatenate user input into SQL',
        'XSS (Cross-Site Scripting): injecting malicious scripts to steal cookies/tokens — mitigated by a Content-Security-Policy header and escaping all output',
        'CSRF (Cross-Site Request Forgery): tricking a logged-in user\'s browser into making an authenticated request — mitigated by SameSite=Strict cookies and CSRF tokens (less relevant for token-based APIs with no cookies)',
        'SSRF (Server-Side Request Forgery): block RFC 1918 private ranges and cloud metadata endpoints (169.254.169.254), and validate any server-fetched URL',
      ],
    ),
    FundamentalConcept(
      id: 'network_security_zero_trust',
      category: 'Security',
      title: 'Zero Trust, Service Mesh & Network Defenses',
      summary:
          'Zero trust flips the old "trusted internal network" model: never trust a request just because it '
          'came from inside the perimeter — every request must be authenticated and authorized, even '
          'service-to-service. A service mesh (Istio, Linkerd) implements this at the infrastructure layer: a '
          'sidecar proxy next to each service handles mTLS, retries, and traffic policy transparently, with a '
          'control plane auto-rotating certificates so no application code changes. On top of that, network '
          'segmentation (VPCs, subnets, security groups with explicit allow rules) keeps databases '
          'unreachable from the public internet, a WAF (Web Application Firewall) inspects and blocks known '
          'attack patterns before they reach the app, and DDoS protection (Cloudflare, AWS Shield) absorbs '
          'volumetric attacks at the edge.',
      keyPoints: [
        'Zero trust: never trust a request based on network location alone — every request, internal or external, is authenticated and authorized',
        'Service mesh (Istio/Linkerd): a sidecar proxy per service handles mTLS, retries, timeouts, and traffic shifting transparently; the control plane rotates certs automatically',
        'Network segmentation: DB in a private subnet, app in another, only the load balancer/CDN faces the internet — security groups define explicit allow rules, default deny',
        'WAF vs DDoS protection: a WAF inspects HTTP traffic for known attack patterns (SQLi, XSS, bad bots); DDoS protection absorbs volumetric floods at the edge before they reach origin servers',
      ],
    ),
    FundamentalConcept(
      id: 'threat_modeling_stride',
      category: 'Security',
      title: 'Threat Modeling with STRIDE',
      summary:
          'Before (or while) designing a system, it helps to systematically ask "how could this be attacked?" '
          'rather than relying on ad hoc intuition. STRIDE is a framework for categorizing threats per '
          'component: Spoofing (pretending to be another user or service), Tampering (modifying data in '
          'transit or at rest without authorization), Repudiation (denying an action occurred, e.g. "I never '
          'initiated that transfer"), Information Disclosure (unauthorized access to sensitive data), Denial '
          'of Service (overwhelming a system to make it unavailable), and Elevation of Privilege (gaining '
          'higher permissions than granted). Applying STRIDE to each component in an architecture surfaces a '
          'mitigation class per threat rather than trying to remember every possible attack from scratch.',
      keyPoints: [
        'Spoofing → mitigated by strong authentication (RS256 JWTs, mTLS, API key verification, MFA)',
        'Tampering → mitigated by encryption, integrity checks (AES-GCM), HMAC signing, and optimistic locking',
        'Repudiation → mitigated by an append-only audit log and digital signatures on sensitive transactions (non-repudiation proof)',
        'Information Disclosure → mitigated by encryption, BOLA checks on every query, field-level encryption, and masking sensitive data in API responses',
        'Denial of Service / Elevation of Privilege → mitigated by rate limiting, auto-scaling, circuit breakers / RBAC-ABAC enforcement with least privilege, respectively',
      ],
    ),
    FundamentalConcept(
      id: 'audit_logging_nonrepudiation',
      category: 'Security',
      title: 'Audit Logging & Non-Repudiation',
      summary:
          'For anything sensitive — a payment, an admin action, a config change — the system needs an '
          'immutable, append-only record of who did what, to what, and when, that operators themselves '
          'cannot modify or delete after the fact. This is what makes an action non-repudiable: cryptographic '
          'proof (a digital signature on the transaction) that a specific user performed a specific action, '
          'strong enough to hold up in a financial dispute. Storage for this kind of log typically uses WORM '
          '(Write Once Read Many) semantics — S3 Object Lock or a dedicated audit backend — so the record is '
          'physically incapable of being overwritten, even by someone with elevated access.',
      keyPoints: [
        'Audit logs are append-only and immutable: operators cannot modify or delete entries, even with elevated privileges',
        'Log every payment, admin action, and config change, always including a trace_id for cross-system correlation during investigation',
        'Non-repudiation: a digital signature on a transaction is cryptographic proof a specific user performed a specific action — key evidence for dispute resolution',
        'WORM (Write Once Read Many) storage, e.g. S3 Object Lock, guarantees log entries physically cannot be overwritten, protecting against a compromised operator covering their tracks',
      ],
    ),
    FundamentalConcept(
      id: 'fintech_security_patterns',
      category: 'Security',
      title: 'Fintech-Specific Security Patterns',
      summary:
          'Financial systems layer a few extra patterns on top of general security practice, because the cost '
          'of a mistake is direct capital loss. Optimistic locking protects account balances from concurrent '
          'writes: an update only succeeds if the row\'s version hasn\'t changed since it was read (UPDATE '
          'wallets SET balance=? WHERE user_id=? AND version=? AND balance >= amount), and zero rows updated '
          'means retry rather than silently corrupting the balance. HMAC request signing and webhook '
          'signature verification (X-Signature: t={ts},v1={sig}) prevent spoofed payment notifications from '
          'being accepted as genuine. Device fingerprinting and behavioral anomaly detection flag account '
          'takeover attempts — a new device combined with a large transaction is a classic trigger for '
          'step-up authentication.',
      keyPoints: [
        'Optimistic locking on balances: UPDATE ... WHERE version = N AND balance >= amount — zero rows affected means a concurrent write happened, so retry rather than corrupt state',
        'HMAC request signing: sign the payload with HMAC-SHA256(secret, timestamp + body); the receiver verifies the signature before processing, preventing tampering and replay',
        'Webhook signature verification (X-Signature header) prevents an attacker from spoofing payment notifications to a merchant',
        'Account Takeover (ATO) is achieved via credential stuffing, phishing, or SIM swap — defended with MFA, anomaly/device-fingerprint-based risk scoring, and step-up authentication',
      ],
    ),
    FundamentalConcept(
      id: 'supply_chain_security',
      category: 'Security',
      title: 'Supply Chain & Dependency Security',
      summary:
          'Modern applications pull in hundreds of third-party dependencies, and a compromised or vulnerable '
          'one is a direct path into your system — the attack doesn\'t need to touch your code at all. '
          'Mitigating this means pinning exact dependency versions (lockfiles like go.sum or '
          'package-lock.json), generating an SBOM (Software Bill of Materials) that inventories every '
          'dependency, and scanning for known CVEs continuously in CI (Snyk, Dependabot, Trivy) rather than '
          'once at release time. Container images add their own surface: scan them for vulnerabilities before '
          'deploy, run as a non-root user, use a read-only filesystem, and prefer minimal distroless base '
          'images that don\'t ship a shell or package manager an attacker could use post-compromise.',
      keyPoints: [
        'Lockfiles (go.sum, package-lock.json) pin exact dependency versions so a build can\'t silently pull in a compromised newer release',
        'SBOM (Software Bill of Materials): a full inventory of every dependency in the application, needed to quickly assess exposure when a new CVE is disclosed',
        'Continuous CVE scanning in CI (Snyk, Dependabot, Trivy) catches vulnerable dependencies before they ship, not just at initial adoption',
        'Container hardening: non-root user, read-only filesystem, no privileged mode, drop all unnecessary Linux capabilities, and prefer distroless base images',
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
    FundamentalConcept(
      id: 'semantic_vector_search',
      category: 'Search',
      title: 'Semantic (Vector) Search',
      summary:
          'Full-text search finds documents that share exact words with the query — it won\'t connect '
          '"sneakers" with "running shoes" unless both words literally appear. Semantic search instead turns '
          'text (or images) into a vector embedding — a point in high-dimensional space where similar '
          'meanings land close together — and finds results by nearest-neighbor search in that space, so '
          '"running shoes" and "sneakers" can match even without sharing a single word. In production, this '
          'means an embedding model (often a hosted API) converts content into vectors ahead of time, which '
          'get indexed in a vector database or a vector index bolted onto an existing search engine, and a '
          'query is embedded the same way at search time to find its nearest neighbors.',
      keyPoints: [
        'An embedding model converts text/images into a vector (point in high-dimensional space) where semantic similarity corresponds to spatial closeness',
        'Search becomes a nearest-neighbor query over vectors, not a keyword match — this is what lets a search for "sneakers" also surface "running shoes"',
        'Approximate Nearest Neighbor (ANN) algorithms (HNSW is the common one) make this fast at scale, trading a small amount of accuracy for speed versus an exact nearest-neighbor scan',
        'In practice, keyword (full-text) and vector search are often combined and their rankings blended — hybrid search — since exact keyword matches (a product SKU, an exact name) still matter alongside semantic matches',
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

  static const _distributedCoordination = [
    FundamentalConcept(
      id: 'distributed_transactions_2pc_saga',
      category: 'Distributed Coordination',
      title: 'Distributed Transactions: 2PC vs Saga',
      summary:
          'A single database transaction is easy: it either all commits or all rolls back. Coordinating a '
          'transaction across multiple services or databases is much harder, and the two standard answers '
          'trade off differently. Two-Phase Commit (2PC) is like getting several shops to agree on one deal: '
          'a coordinator asks every participant to prepare and vote, and only commits once everyone says yes '
          '— strongly consistent, but participants hold locks while waiting, so one slow or dead node blocks '
          'everyone. A Saga instead runs each step and, if a later step fails, executes compensating actions '
          'to undo the earlier ones — no locks held across services, better availability, but the system '
          'passes through visibly inconsistent intermediate states.',
      keyPoints: [
        '2PC: coordinator asks all participants to prepare, then commits only if everyone votes yes — strongly consistent, but locks are held the whole time, so it does not scale well and one dead participant blocks the rest',
        'Saga: execute each local transaction in sequence, and if a step fails, run compensating transactions to undo the completed steps — no cross-service locks, but requires designing an "undo" for every step',
        'Sagas can be orchestrated (a central coordinator tells each service what to do) or choreographed (each service reacts to events from the previous one) — orchestration is easier to reason about, choreography has less coupling',
        'Reach for a Saga in most modern microservice designs; 2PC still shows up where strict atomicity is non-negotiable and participants are few and reliable',
      ],
    ),
    FundamentalConcept(
      id: 'gossip_protocol',
      category: 'Distributed Coordination',
      title: 'Gossip Protocol',
      summary:
          'In a large cluster, having every node talk to every other node to stay in sync doesn\'t scale. '
          'Gossip (epidemic) protocols spread information the way rumors spread through a crowd: each node '
          'periodically picks a few random peers and shares what it knows (cluster membership, health status, '
          'key-value updates); those peers do the same on their next round. Within a small number of rounds, '
          'information reaches the whole cluster with no central coordinator and no single point of failure — '
          'used by Cassandra and DynamoDB-style systems for membership and failure detection.',
      keyPoints: [
        'Each node periodically gossips with a few random peers rather than broadcasting to everyone — bandwidth stays flat as the cluster grows',
        'Information (membership changes, failure detection, state updates) propagates exponentially: after a few rounds, the whole cluster has converged',
        'Failure detection via gossip: nodes periodically say "still here!"; missing a few heartbeats gets a node marked suspect, and the news of that spreads via gossip too',
        'No central coordinator and no single point of failure — a natural fit for large, dynamic clusters like Cassandra where membership constantly changes',
      ],
    ),
    FundamentalConcept(
      id: 'vector_clocks_hlc',
      category: 'Distributed Coordination',
      title: 'Vector Clocks & Hybrid Logical Clocks',
      summary:
          'In a distributed system, physical clocks on different machines are never perfectly in sync, but '
          'you often still need to know "did event A happen before event B?" A vector clock tracks a counter '
          'per node; comparing two vector clocks tells you whether one event causally happened before another, '
          'or whether they\'re truly concurrent (neither caused the other) — this is exactly what lets '
          'systems like Dynamo detect conflicting concurrent writes to the same key. A Hybrid Logical Clock '
          '(HLC) combines a logical counter with wall-clock time, giving timestamps that are both roughly '
          '"real time" for humans and guaranteed to respect causal order, even when the underlying clocks '
          'disagree slightly.',
      keyPoints: [
        'Vector clocks assign each node its own counter; comparing two vector clocks reveals whether one event causally preceded another, or whether they were concurrent',
        'Concurrent (conflicting) writes detected via vector clocks is how Dynamo-style databases know to surface a conflict for the application (or a CRDT) to resolve, rather than silently picking a winner',
        'A Hybrid Logical Clock blends a logical counter with physical time, so timestamps stay causally correct even when node clocks are slightly out of sync',
        'Neither approach requires perfectly synchronized clocks (unlike naive last-write-wins by wall-clock time, which can silently lose data when clocks drift)',
      ],
    ),
    FundamentalConcept(
      id: 'merkle_trees',
      category: 'Distributed Coordination',
      title: 'Merkle Trees for Anti-Entropy',
      summary:
          'When two replicas might have diverged and need to be reconciled, comparing every single record '
          'between them is far too slow at scale. A Merkle tree solves this by hashing data in a tree '
          'structure: each leaf hashes a block of data, and each parent hashes its children\'s hashes, up to '
          'a single root hash. Two replicas can compare just their root hashes — if they match, the replicas '
          'are identical, full stop. If they differ, only the branches whose hashes disagree need to be '
          'walked and compared further, narrowing in on the actual divergence in logarithmic time instead of '
          'a full scan.',
      keyPoints: [
        'Leaves hash data blocks; parents hash the concatenation of their children\'s hashes, all the way up to one root hash representing the entire dataset',
        'Comparing two replicas is a single root-hash comparison: identical roots mean the data is identical, no further work needed',
        'When roots differ, only the mismatched branches are walked further — this is what makes anti-entropy repair in Cassandra/Dynamo-style systems cheap even for huge datasets',
        'The same idea underlies Git (comparing commit trees) and blockchains (comparing block contents) — it\'s a general technique for cheaply detecting where two large datasets diverge',
      ],
    ),
  ];

  static const _dataStructuresForScale = [
    FundamentalConcept(
      id: 'bloom_cuckoo_filters',
      category: 'Data Structures for Scale',
      title: 'Bloom & Cuckoo Filters',
      summary:
          'Sometimes you need to answer "have I seen this before?" over billions of items without the memory '
          'to store them all. A Bloom filter is a tiny bouncer: it can say "definitely not on the list" with '
          '100% certainty, or "maybe on the list" with a small, tunable false-positive rate — but it can '
          'never produce a false negative, and it can never remove an item once added. A Cuckoo filter '
          'answers the same question but also supports deletion, at a modest cost in extra complexity and '
          'memory. Both are used to cheaply avoid expensive work: checking a Bloom filter before hitting the '
          'database saves a lookup whenever the answer is a guaranteed "no."',
      keyPoints: [
        'Bloom filter: no false negatives ever, small tunable false-positive rate, cannot support deletion once bits are set',
        'Cuckoo filter: same probabilistic membership test as Bloom, but supports removing items — the tradeoff is somewhat higher memory and complexity',
        'Classic use: check a Bloom filter before an expensive database/disk lookup — a "definitely not present" answer skips the lookup entirely',
        'LSM-tree databases (Cassandra, RocksDB) use Bloom filters per SSTable to avoid checking files that certainly don\'t contain the key being looked up',
      ],
    ),
    FundamentalConcept(
      id: 'hyperloglog',
      category: 'Data Structures for Scale',
      title: 'HyperLogLog (Cardinality Estimation)',
      summary:
          'Counting the exact number of distinct items in a massive stream (unique visitors, unique search '
          'terms) normally means storing every distinct value you\'ve seen — expensive at scale. HyperLogLog '
          'is a probabilistic data structure that estimates that count using a tiny, fixed amount of memory '
          '(a few kilobytes, regardless of whether you\'re counting thousands or billions of items), accepting '
          'a small, well-understood margin of error (typically under 2%) in exchange for that huge memory '
          'saving. Redis ships it built in (PFADD/PFCOUNT) precisely for this "roughly how many uniques" use '
          'case.',
      keyPoints: [
        'Trades exactness for memory: a few KB of memory estimates cardinality with ~2% error, regardless of whether the true count is thousands or billions',
        'Ideal for "approximately how many distinct X" questions: unique visitors, unique search queries, unique IPs — not for anything requiring an exact count',
        'Redis exposes it natively via PFADD (add an item) and PFCOUNT (estimate cardinality) — no custom implementation needed in most stacks',
        'Multiple HyperLogLog sketches can be merged (union) without losing accuracy, letting you combine per-shard or per-hour counts into a total estimate',
      ],
    ),
    FundamentalConcept(
      id: 'consistent_hashing',
      category: 'Data Structures for Scale',
      title: 'Consistent Hashing',
      summary:
          'Naive sharding — hash(key) % N — breaks catastrophically when N (the number of nodes) changes: '
          'almost every key remaps to a different node, causing a massive, unnecessary reshuffle. Consistent '
          'hashing solves this by placing both nodes and keys on a hash ring: a key belongs to the first node '
          'found walking clockwise from its position. Adding or removing a node only affects the keys between '
          'it and its immediate neighbor on the ring — everything else stays put. Virtual nodes (each physical '
          'node claiming several positions on the ring) smooth out load distribution so one physical node '
          'doesn\'t end up disproportionately hot.',
      keyPoints: [
        'Naive hash(key) % N reshuffles nearly all keys whenever N changes — consistent hashing avoids this by design',
        'Nodes and keys are placed on a hash ring; a key is owned by the next node clockwise from its position',
        'Adding/removing a node only remaps the keys between it and its neighbor — the rest of the ring is untouched',
        'Virtual nodes: each physical node claims multiple ring positions, spreading load evenly and avoiding hot spots when the cluster is small or uneven',
        'Used throughout distributed caches and databases (DynamoDB, Cassandra, memcached client-side sharding) wherever the node count needs to change without a full data migration',
      ],
    ),
  ];
  static const _databaseInternals = [
    FundamentalConcept(
      id: 'btree_vs_lsm',
      category: 'Database Internals',
      title: 'B-Tree vs LSM Tree',
      summary:
          'Every database has to pick a storage engine, and the two dominant designs make opposite '
          'tradeoffs. A B-tree edits data in place, like editing a binder directly — reads are fast (log-N '
          'lookups straight to the record) but writes involve random disk I/O to update the right page. An '
          'LSM (Log-Structured Merge) tree instead appends writes sequentially to an in-memory memtable '
          '(mirrored to a write-ahead log for durability), and later flushes and merges those into sorted '
          'files on disk (SSTables) in the background — writes are fast because they\'re just sequential '
          'appends, at the cost of reads sometimes needing to check several files and background compaction '
          'work.',
      keyPoints: [
        'B-tree: edits pages in place — read-optimized (Postgres, MySQL InnoDB), but writes cause random disk I/O',
        'LSM tree: writes go to an in-memory memtable + write-ahead log, later flushed to immutable sorted SSTables on disk — write-optimized (Cassandra, RocksDB, LevelDB)',
        'Compaction: a background process merges and tidies SSTables, removing overwritten/deleted entries so reads don\'t have to check an ever-growing number of files',
        'Choose B-tree-based stores when reads dominate and consistency of a single record matters; choose LSM-based stores when write throughput is the bottleneck',
      ],
    ),
    FundamentalConcept(
      id: 'oltp_vs_olap',
      category: 'Database Internals',
      title: 'OLTP vs OLAP',
      summary:
          'OLTP (Online Transaction Processing) is the busy cash register: many small, fast reads and writes '
          '— "get this user," "insert this order" — the workload a typical application database (Postgres, '
          'MySQL) is built for. OLAP (Online Analytical Processing) is the accountant crunching numbers '
          'overnight: fewer, much larger queries that scan and aggregate millions of rows — "average revenue '
          'per region last quarter." These workloads compete for the same resources if run on the same '
          'database, so production systems typically separate them: OLTP serves the live app, and data is '
          'periodically piped into a dedicated OLAP/analytics store built for scanning, not point lookups.',
      keyPoints: [
        'OLTP: many small, low-latency reads/writes on individual rows — the live application workload (Postgres, MySQL, DynamoDB)',
        'OLAP: fewer, large aggregate queries scanning millions of rows — analytics/reporting workload (Snowflake, BigQuery, Redshift, ClickHouse)',
        'Running heavy OLAP queries directly against an OLTP database competes for the same resources and can degrade live application performance',
        'The usual pattern: OLTP is the source of truth for the app; data is periodically ETL\'d/streamed into a separate OLAP store built for scanning',
      ],
    ),
    FundamentalConcept(
      id: 'data_warehouse_lake_lakehouse',
      category: 'Database Internals',
      title: 'Data Warehouse, Lake & Lakehouse',
      summary:
          'A data warehouse stores structured, cleaned, schema-enforced data optimized for fast analytical '
          'queries — tidy labeled shelves. A data lake stores raw data of any shape (structured, semi-'
          'structured, unstructured) cheaply at massive scale, deferring schema decisions until read time — a '
          'big, flexible dumping ground. A lakehouse tries to get the best of both: cheap object storage like '
          'a lake, but with warehouse-style schema enforcement, ACID transactions, and fast query performance '
          'layered on top (Delta Lake, Apache Iceberg) — a dumping ground with a librarian keeping it '
          'organized.',
      keyPoints: [
        'Data warehouse: structured, schema-enforced, optimized for fast analytical (OLAP) queries — but expensive to store huge raw volumes and inflexible to schema changes',
        'Data lake: cheap, flexible storage for any data shape, schema decided at read time — but can become a disorganized "data swamp" without governance',
        'Lakehouse: combines lake-style cheap storage with warehouse-style schema enforcement, ACID transactions, and query performance (Delta Lake, Apache Iceberg)',
        'Columnar storage formats (Parquet, ORC) underpin most modern warehouses/lakehouses, since analytical queries typically read a few columns across many rows, not full rows',
      ],
    ),
    FundamentalConcept(
      id: 'change_data_capture',
      category: 'Database Internals',
      title: 'Change Data Capture (CDC)',
      summary:
          'Change Data Capture reads a database\'s own internal transaction log (the WAL in Postgres, the '
          'binlog in MySQL) and streams every change out — inserts, updates, deletes — to downstream '
          'consumers, without adding load to the source database or requiring application code changes. '
          'Tools like Debezium tail this log and publish changes to a message queue (typically Kafka), which '
          'is how a search index, a cache, an OLAP warehouse, or another service can be kept in sync with a '
          'primary database in near real time.',
      keyPoints: [
        'CDC tails the database\'s own transaction log (WAL/binlog) rather than polling or requiring app-level dual writes',
        'Debezium is the standard open-source tool for this — it publishes every row-level change as an event to Kafka',
        'Downstream consumers (search index, cache invalidation, analytics warehouse, another microservice) subscribe to the change stream and stay in sync near-real-time',
        'CDC avoids dual-write bugs: instead of the app writing to the DB and separately trying to write to Elasticsearch/Kafka (which can get out of sync if one write fails), the log itself is the single source of truth for what changed',
      ],
    ),
    FundamentalConcept(
      id: 'normalize_vs_denormalize',
      category: 'Database Internals',
      title: 'Normalization vs Denormalization',
      summary:
          'Normalizing a schema means storing each fact exactly once and linking related data via foreign '
          'keys — no duplication, no update anomalies, but reads often need joins across several tables. '
          'Denormalizing means deliberately duplicating data to avoid those joins — a post might store the '
          'author\'s display name directly, instead of joining to the users table every time — trading some '
          'storage and write complexity (update the name in two places) for much faster, simpler reads. '
          'NoSQL and high-scale systems generally lean denormalized, designing the schema around the exact '
          'read queries the application needs, since there are no cheap joins to rescue you later.',
      keyPoints: [
        'Normalized: each fact stored once, linked by foreign keys — no duplication, but reads need joins',
        'Denormalized: data duplicated deliberately to avoid joins at read time — faster reads, at the cost of extra storage and more complex writes/updates',
        'Query-first design (common in NoSQL): model the schema around the exact read queries the app needs, since there\'s no join to fall back on',
        'A common middle ground: normalize the OLTP source of truth, denormalize into read-optimized views/caches for the hot query paths',
      ],
    ),
  ];
  static const _architecturePatterns = [
    FundamentalConcept(
      id: 'microservices_vs_monolith',
      category: 'Architecture Patterns',
      title: 'Microservices vs Monolith',
      summary:
          'A monolith is one giant food truck doing everything: a single deployable codebase and database, '
          'simple to develop and deploy early on, but as it grows, every team\'s changes compete for the same '
          'release, and any part scaling means scaling the whole thing. Microservices split that into a food '
          'court of small, independently deployable, independently scalable services, each owning its own '
          'data — better team autonomy and targeted scaling, at the cost of new distributed-systems problems '
          '(network calls instead of function calls, eventual consistency across services, much more '
          'operational complexity). Conway\'s Law is the underlying reason this matters: however your teams '
          'are organized is how your software ends up shaped, so service boundaries should generally follow '
          'team boundaries.',
      keyPoints: [
        'Monolith: one codebase, one deployment, simplest to start with — but scaling, deploying, and evolving parts independently gets harder as it grows',
        'Microservices: independently deployable/scalable services, each owning its own data — better autonomy, but introduces network calls, eventual consistency, and real operational overhead',
        'Conway\'s Law: system structure mirrors team communication structure — service boundaries that fight your team structure tend to cause friction',
        'Neither is "correct" by default: most successful systems start as a monolith and extract services only where independent scaling or team ownership genuinely pays for the added complexity',
      ],
    ),
    FundamentalConcept(
      id: 'cqrs_event_sourcing',
      category: 'Architecture Patterns',
      title: 'CQRS & Event Sourcing',
      summary:
          'CQRS (Command Query Responsibility Segregation) splits the write model from the read model: '
          'writes go through a model optimized for validating and applying changes, while reads are served '
          'from a separately optimized (often denormalized, sometimes eventually consistent) view — useful '
          'when read and write patterns are wildly different in shape or scale. Event Sourcing takes this '
          'further: instead of storing only the current state, it stores the full sequence of events that led '
          'to it (like a bank keeping every transaction rather than just the current balance) — the current '
          'state is just a replay/fold over the event log, which gives a complete audit trail and lets you '
          'rebuild any past state or add new read models later by replaying history.',
      keyPoints: [
        'CQRS: separate models for writes (commands) and reads (queries) — the read side can be a denormalized, purpose-built view without complicating the write side\'s validation logic',
        'Event Sourcing: store the sequence of events, not just current state — current state is derived by replaying/folding over the event log',
        'Event sourcing gives a full audit trail for free and lets you add new read models later by replaying history — but querying "current state" directly requires building projections',
        'CQRS and event sourcing are often paired but are independent choices — you can do CQRS without event sourcing, and vice versa',
      ],
    ),
    FundamentalConcept(
      id: 'circuit_breaker_bulkhead',
      category: 'Architecture Patterns',
      title: 'Circuit Breaker & Bulkhead',
      summary:
          'A circuit breaker works like an electrical fuse: if calls to a downstream dependency keep failing, '
          'it "trips" and stops sending traffic to it for a while, failing fast locally instead of piling up '
          'slow, doomed requests — then periodically lets a trial request through to check if the dependency '
          'has recovered before fully closing again. This prevents one failing dependency from cascading into '
          'a system-wide outage by exhausting threads/connections waiting on it. A bulkhead applies the same '
          '"contain the damage" idea structurally: partition resources (connection pools, thread pools) per '
          'dependency, like watertight compartments in a ship\'s hull, so one dependency\'s failure can\'t '
          'starve resources needed by everything else.',
      keyPoints: [
        'Circuit breaker states: closed (calls flow normally) → open (calls fail immediately, no traffic sent) → half-open (a trial request checks if the dependency recovered)',
        'Failing fast when a dependency is down is better than piling up slow, timing-out requests that exhaust threads/connections waiting on it',
        'Bulkhead: partition resource pools (connections, threads) per dependency, so one failing dependency cannot starve resources needed by unrelated calls',
        'Both patterns exist to contain the blast radius of a single dependency\'s failure rather than let it cascade through the whole system',
      ],
    ),
    FundamentalConcept(
      id: 'service_mesh_sidecar',
      category: 'Architecture Patterns',
      title: 'Service Mesh & Sidecar Pattern',
      summary:
          'The sidecar pattern gives every worker a personal assistant handling all their calls the same way, '
          'so the worker just does the job: a proxy process (Envoy) runs alongside each service instance, '
          'handling mTLS, retries, timeouts, load balancing, and telemetry transparently — pushing that '
          'cross-cutting networking logic out of application code and into infrastructure. A service mesh '
          '(Istio, Linkerd) is the resulting system of sidecars plus a control plane that configures them all '
          'centrally, so policies like "retry 3 times" or "route 10% of traffic to the canary" are set once at '
          'the mesh level instead of reimplemented in every service\'s code.',
      keyPoints: [
        'Sidecar: a proxy (Envoy) runs alongside each service instance, transparently handling networking concerns (mTLS, retries, timeouts, load balancing, telemetry)',
        'Control plane (Istio/Linkerd) configures every sidecar centrally — traffic policy changes don\'t require redeploying application code',
        'Pushes cross-cutting infrastructure concerns below the application layer, so every service gets consistent behavior without reimplementing it',
        'Adds real operational complexity and latency overhead per hop — worth it primarily once you have enough services that reimplementing this logic per-service becomes the bigger cost',
      ],
    ),
    FundamentalConcept(
      id: 'api_gateway_bff',
      category: 'Architecture Patterns',
      title: 'API Gateway & Backend-for-Frontend',
      summary:
          'An API Gateway sits in front of a set of services like a restaurant\'s front desk: clients never '
          'learn which backend actually handled their request. It centralizes cross-cutting concerns — '
          'authentication, coarse-grained rate limiting, request routing, and basic authorization — before a '
          'request ever reaches a specific service, so individual services don\'t each reimplement that '
          'logic. A Backend-for-Frontend (BFF) takes this further by giving each client type (web, iOS, '
          'Android) its own tailored gateway/aggregation layer, shaped around what that specific client '
          'actually needs — instead of one generic API forcing every client to over-fetch or make several '
          'round trips to assemble a screen\'s worth of data.',
      keyPoints: [
        'API Gateway: single entry point handling auth, rate limiting, routing, and coarse authorization centrally, before requests reach individual services',
        'Clients never learn which backend service actually handled the request — the gateway is the only thing they talk to directly',
        'BFF (Backend-for-Frontend): a dedicated gateway/aggregation layer per client type, shaped around that client\'s exact data needs, avoiding generic-API over-fetching or excessive round trips',
        'Tradeoff: a gateway is a new operational component and potential bottleneck/single point of failure if not scaled and made highly available itself',
      ],
    ),
    FundamentalConcept(
      id: 'n_tier_thick_thin_client',
      category: 'Architecture Patterns',
      title: 'N-Tier Architecture & Thick vs Thin Clients',
      summary:
          'N-tier architecture describes how many distinct layers a request passes through: a 2-tier system '
          'is just client and server; 3-tier adds a dedicated application/business-logic layer between the '
          'client and the database; further tiers might add a gateway that authenticates and routes before '
          'anything else is reached. Separately, thick vs thin client describes how much logic lives on the '
          'client itself: a thick client (a native desktop app, a feature-rich mobile app with local data and '
          'business logic) does significant work locally, while a thin client (a basic browser page, a simple '
          'API consumer) does almost nothing locally and depends on the server for everything — trading '
          'client capability and offline support against how much you can update centrally without shipping a '
          'new client release.',
      keyPoints: [
        'N-tier: how many distinct layers a request crosses — 2-tier (client-server), 3-tier (adds an app/business-logic layer), N-tier (adds gateways, caches, etc.)',
        'More tiers generally mean better separation of concerns and independent scaling per layer, at the cost of more network hops and operational pieces',
        'Thick client: significant logic and data live on the client (native apps, offline-capable apps) — richer UX and offline support, harder to update everyone at once',
        'Thin client: minimal client logic, server does the work — trivial to update (change the server, every client benefits immediately), but requires connectivity and pushes more load server-side',
      ],
    ),
    FundamentalConcept(
      id: 'strangler_fig_pattern',
      category: 'Architecture Patterns',
      title: 'Strangler Fig Pattern (Incremental Migration)',
      summary:
          'Migrating a legacy system all at once is risky — a "big bang" rewrite can take months, and until '
          'it ships, you\'re maintaining two systems with no way to validate the new one against real '
          'traffic. The strangler fig pattern migrates incrementally instead, named after a vine that grows '
          'around a host tree and gradually replaces it without ever felling it outright: route a small slice '
          'of traffic (one endpoint, one feature) to the new implementation behind a router/proxy, verify it '
          'behaves correctly, then expand the slice — old and new run side by side the whole time, and the '
          'legacy system is only decommissioned once nothing routes to it anymore.',
      keyPoints: [
        'Incrementally redirect traffic from the old system to the new one, one slice (endpoint/feature) at a time, rather than a risky all-at-once cutover',
        'Old and new systems run side by side throughout the migration — a router/proxy decides which system handles each request',
        'Each migrated slice can be validated against real production traffic before expanding further, catching correctness issues early and cheaply',
        'The legacy system is only decommissioned once every code path has been migrated and nothing routes to it anymore — there is no single risky "flip the switch" moment',
      ],
    ),
  ];
  static const _communicationProtocols = [
    FundamentalConcept(
      id: 'http_evolution',
      category: 'Communication Protocols',
      title: 'HTTP/1.1 vs HTTP/2 vs HTTP/3',
      summary:
          'Each HTTP version solved a specific bottleneck in the one before it, like the same postal service '
          'getting successive upgrades. HTTP/1.1 sends one request at a time per connection (browsers work '
          'around this by opening several parallel connections). HTTP/2 multiplexes many requests down a '
          'single TCP connection with binary framing and header compression, removing the need for those '
          'workaround connections and cutting overhead significantly — but a single lost packet still blocks '
          'every multiplexed stream on that one TCP connection (head-of-line blocking at the transport '
          'layer). HTTP/3 fixes that by dropping TCP entirely in favor of QUIC over UDP, so one stream\'s lost '
          'packet no longer stalls the others, and connections survive a client\'s network change (e.g. '
          'wifi-to-cellular) without a fresh handshake.',
      keyPoints: [
        'HTTP/1.1: one request in flight per connection — browsers open multiple parallel connections as a workaround, adding overhead',
        'HTTP/2: multiplexes many requests over one TCP connection with binary framing and header compression — but a single lost TCP packet blocks all multiplexed streams on that connection',
        'HTTP/3: runs over QUIC (UDP-based) instead of TCP, so packet loss on one stream no longer head-of-line-blocks the others, and it survives network changes without renegotiating',
        'Each version is backward-compatible in intent — HTTP/3 negotiates down to HTTP/2 or 1.1 when a client or network path doesn\'t support QUIC',
      ],
    ),
    FundamentalConcept(
      id: 'grpc_protobuf',
      category: 'Communication Protocols',
      title: 'gRPC & Protocol Buffers',
      summary:
          'REST over JSON is human-readable and universally supported, but that readability costs bytes and '
          'parsing time — fine for browser-facing APIs, wasteful for high-volume internal service-to-service '
          'traffic. gRPC is built for that internal case: it runs over HTTP/2 and serializes messages with '
          'Protocol Buffers (protobuf), a compact binary format defined by a strict schema (a .proto file), '
          'which is both smaller on the wire and faster to encode/decode than JSON. Because the schema is '
          'explicit and code-generated on both ends, client and server stay in sync by construction, and gRPC '
          'gets streaming (client, server, or bidirectional) for free from HTTP/2, which plain REST does not '
          'have a standard answer for.',
      keyPoints: [
        'Protobuf: a compact binary serialization format defined by a strict, versioned schema (.proto file) — smaller and faster than JSON, but not human-readable off the wire',
        'gRPC runs over HTTP/2, inheriting multiplexing and giving native client/server/bidirectional streaming without extra machinery',
        'Schema-first design means client and server stubs are code-generated from the same .proto file, catching mismatches at compile time rather than at runtime',
        'Best fit: internal service-to-service (microservice-to-microservice) traffic where performance matters; REST/JSON remains the more accessible default for public/browser-facing APIs',
      ],
    ),
    FundamentalConcept(
      id: 'webrtc_and_realtime',
      category: 'Communication Protocols',
      title: 'WebRTC & Picking a Real-Time Protocol',
      summary:
          'WebRTC lets two clients — two browsers on a video call — talk directly to each other peer-to-peer, '
          'with a signaling server only helping them find each other and negotiate the connection before '
          'stepping out of the data path; it\'s encrypted by default and built for the low latency real-time '
          'audio/video demands, tolerating some packet loss rather than retransmitting (which would add '
          'unacceptable delay). More broadly, picking the right real-time protocol is about matching the '
          'shape of the interaction: plain HTTP for simple request/response, gRPC for internal robot-to-robot '
          'calls, WebSockets for a persistent two-way chat channel, Server-Sent Events for a one-way ticker '
          'the server pushes to the client, and WebRTC specifically when you need direct peer-to-peer media.',
      keyPoints: [
        'WebRTC connects two peers directly (browser-to-browser); a signaling server only helps them discover each other and negotiate, then steps out of the media path entirely',
        'Built for real-time audio/video: prioritizes low latency over reliability, tolerating some packet loss instead of retransmitting (which would add delay a video/voice call can\'t afford)',
        'Encrypted by default (DTLS-SRTP) — unlike plain WebSockets, security isn\'t an opt-in add-on',
        'Protocol picker: HTTP (simple request/response) · gRPC (internal service-to-service) · WebSocket (persistent bidirectional chat/collab) · SSE (one-way server push, e.g. live scores) · WebRTC (direct peer-to-peer media)',
      ],
    ),
  ];
  static const _reliabilityResilience = [
    FundamentalConcept(
      id: 'retries_backoff_jitter',
      category: 'Reliability & Resilience',
      title: 'Retries with Exponential Backoff & Jitter',
      summary:
          'A failed request often just needs a retry — but retrying immediately, especially from many clients '
          'at once, can make things worse: if the line\'s busy, everyone redialing instantly just re-floods '
          'the same busy line. Exponential backoff waits progressively longer between each retry attempt '
          '(1s, 2s, 4s, 8s...), giving a struggling dependency room to recover instead of hammering it '
          'harder. Adding jitter — a random amount added to each wait — prevents many clients that failed at '
          'the same moment from retrying in perfect lockstep and re-creating the exact same spike they were '
          'trying to avoid. Retries should also always pair with a cap on total attempts and a timeout, so a '
          'genuinely dead dependency doesn\'t get retried forever.',
      keyPoints: [
        'Exponential backoff: each retry waits longer than the last (e.g. doubling), giving the failing dependency room to recover instead of being hit harder while it\'s already struggling',
        'Jitter: add randomness to each wait so many clients that failed simultaneously don\'t all retry in lockstep, recreating the exact spike backoff was meant to avoid',
        'Always cap total retry attempts and set an overall timeout — a dependency that\'s truly down should fail the caller eventually, not retry forever',
        'Only retry idempotent operations safely by default — retrying a non-idempotent "charge the card" request risks a duplicate side effect unless paired with an idempotency key',
      ],
    ),
    FundamentalConcept(
      id: 'delivery_semantics',
      category: 'Reliability & Resilience',
      title: 'Delivery Semantics & Dead Letter Queues',
      summary:
          'When a message might be lost, duplicated, or delivered exactly once, the guarantee a system '
          'promises matters a lot. At-most-once means a message might be lost but is never duplicated — fire '
          'and forget. At-least-once means a message is never lost but might be delivered more than once — '
          'the sender retries until it gets an acknowledgment, and the receiver needs to handle duplicates '
          '(usually via idempotency). Exactly-once is the hardest guarantee and, across a real network, is '
          'effectively at-least-once delivery combined with idempotent processing on the receiving end, not a '
          'magic trick that eliminates duplicates at the transport layer. A dead letter queue catches messages '
          'that repeatedly fail processing, so they don\'t block the queue forever or get silently dropped — '
          'they land somewhere for inspection and reprocessing instead.',
      keyPoints: [
        'At-most-once: might lose a message, never duplicates it — simplest, acceptable only when occasional loss is tolerable',
        'At-least-once: never loses a message, might deliver it more than once — the sender retries until acknowledged; the receiver must tolerate duplicates',
        'Exactly-once in practice = at-least-once delivery + idempotent processing on the receiver, not a transport-layer guarantee that eliminates duplicates outright',
        'Dead letter queue (DLQ): messages that repeatedly fail processing are routed here instead of blocking the queue or being silently dropped, for later inspection/reprocessing',
      ],
    ),
    FundamentalConcept(
      id: 'health_checks_liveness_readiness',
      category: 'Reliability & Resilience',
      title: 'Health Checks: Liveness vs Readiness',
      summary:
          'Two different questions get conflated under "is this service healthy?" A liveness check asks "is '
          'this process alive, or should it be restarted?" — a hung or deadlocked process fails liveness and '
          'gets killed and restarted. A readiness check asks a narrower question: "is this instance ready to '
          'take traffic right now?" — a perfectly alive process might still be unready during startup (still '
          'loading data), or temporarily unready if a dependency it needs is down, without needing a restart '
          'at all. Load balancers and orchestrators (Kubernetes) use readiness to decide whether to route '
          'traffic to an instance, and liveness to decide whether to kill and replace it — conflating the two '
          'causes either unnecessary restarts or traffic sent to instances that can\'t actually serve it.',
      keyPoints: [
        'Liveness: "is the process alive, or should it be restarted?" — a failing liveness check triggers a restart',
        'Readiness: "should traffic be routed to this instance right now?" — a failing readiness check just pulls it out of rotation, no restart',
        'A service can be alive but not ready (still starting up, warming a cache) — restarting it in that state would be actively harmful, just delaying startup further',
        'Kubernetes uses both probes for exactly this split: readinessProbe controls Service traffic routing, livenessProbe controls whether the pod gets restarted',
      ],
    ),
    FundamentalConcept(
      id: 'graceful_degradation_deploy_strategies',
      category: 'Reliability & Resilience',
      title: 'Graceful Degradation & Deployment Strategies',
      summary:
          'Graceful degradation means that when a non-critical feature breaks, the system shows a plain, '
          'working fallback instead of a blank error page — a recommendations widget failing shouldn\'t take '
          'down the whole product page. The same "don\'t risk everything at once" thinking shapes how new code '
          'ships: rolling deployments replace instances batch by batch with no extra fleet needed, but run '
          'mixed versions during the rollout; blue-green deployments run two complete environments and flip '
          'traffic instantly (with instant rollback), at roughly double the infrastructure cost; canary '
          'releases send a small percentage of traffic to the new version, watch real metrics, then ramp up — '
          'limiting the blast radius of a bad release to a small slice of users instead of everyone at once. '
          'Feature flags add a fourth lever: a runtime switch that turns a feature on/off without a redeploy '
          'at all.',
      keyPoints: [
        'Graceful degradation: a broken non-critical feature shows a fallback, not a page-wide error — failure is isolated to what actually broke',
        'Rolling deployment: batch-by-batch instance replacement, no extra fleet, but the system runs mixed old/new versions mid-rollout',
        'Blue-green: two full environments, instant traffic flip and instant rollback, at roughly 2x infrastructure cost during the transition',
        'Canary: release to a small percentage of traffic first, watch metrics, then ramp up — limits the blast radius of a bad release before it reaches everyone',
        'Feature flags: a runtime on/off switch for a feature, decoupling "deploy the code" from "turn on the behavior" entirely',
      ],
    ),
    FundamentalConcept(
      id: 'chaos_engineering',
      category: 'Reliability & Resilience',
      title: 'Chaos Engineering',
      summary:
          'Chaos engineering means deliberately injecting failures into a system — killing a random instance, '
          'adding artificial network latency, simulating a dependency outage — in a controlled way, so '
          'weaknesses surface on your own terms during business hours with a team watching, rather than '
          'during a real 3am incident. Netflix\'s Chaos Monkey, which randomly terminates production instances '
          'to force resilience to actual instance loss, is the best-known example. The point isn\'t chaos for '
          'its own sake: each experiment starts from a hypothesis ("the system should keep serving reads if '
          'this replica dies"), runs against a small blast radius first, and either confirms the system is '
          'resilient or surfaces a real gap worth fixing before it happens for real.',
      keyPoints: [
        'Deliberately inject failures (kill instances, add latency, simulate outages) in a controlled environment to find weaknesses before they happen unplanned',
        'Netflix\'s Chaos Monkey randomly terminates production instances specifically to force every service to tolerate real instance loss, continuously',
        'Each experiment starts from a hypothesis about expected behavior under failure, and is run with a small blast radius first, expanding as confidence grows',
        'The goal is confirming resilience (or finding a real gap) on your own schedule, with a team watching — not discovering the gap for the first time during a live incident',
      ],
    ),
    FundamentalConcept(
      id: 'cascading_failures_thundering_herd',
      category: 'Reliability & Resilience',
      title: 'Cascading Failures & Thundering Herd',
      summary:
          'A cascading failure is one falling domino knocking over the rest: an initial failure (one '
          'overloaded service) causes retries and timeouts that overload its neighbors, which then fail too, '
          'spreading through the whole system — this is exactly why circuit breakers, bulkheads, and sane '
          'retry/backoff exist. A thundering herd is a specific, common trigger: when a popular cached item '
          'expires or a popular resource becomes unavailable, every waiting request stampedes the origin at '
          'the exact same moment, overwhelming it — the factory getting swarmed the instant the popular item '
          'runs out. Mitigations include staggering cache expirations (so not everything expires '
          'simultaneously), request coalescing (only one request actually goes to the origin while others '
          'wait for that result), and jittered retries.',
      keyPoints: [
        'Cascading failure: one component\'s failure causes retries/timeouts that overload its neighbors, which then fail too, spreading through the system',
        'Circuit breakers, bulkheads, and backoff/jitter all exist specifically to stop a local failure from cascading into a system-wide outage',
        'Thundering herd: a popular cache entry expiring (or a resource becoming unavailable) causes every waiting request to hit the origin at the exact same instant',
        'Mitigations: stagger cache TTLs so items don\'t all expire simultaneously, use request coalescing (one in-flight request per key, others wait for its result), and jitter retries',
      ],
    ),
  ];
  static const _idsAndEstimation = [
    FundamentalConcept(
      id: 'id_generation_snowflake_uuid',
      category: 'IDs & Estimation',
      title: 'Distributed ID Generation: Snowflake, UUID & ULID',
      summary:
          'A single auto-incrementing counter doesn\'t work once IDs need to be generated by many machines '
          'independently — two machines would eventually hand out the same number. A UUID (v4) sidesteps this '
          'with a large random value so unique that two will basically never collide, but it\'s not sortable '
          'and doesn\'t compress well in a B-tree index. Snowflake IDs (used at Twitter, Discord, and many '
          'others) instead stamp together a timestamp, a machine/worker ID, and a per-millisecond counter — '
          'unique across machines without any coordination, and roughly sortable by creation time since the '
          'timestamp is the high-order bits. ULID is a newer alternative in the same spirit as UUID but '
          'time-sortable and more compact to read, splitting the difference between the two approaches.',
      keyPoints: [
        'UUID v4: fully random, essentially collision-proof, but not sortable and index-unfriendly (random values scatter across a B-tree)',
        'UUID v7 / ULID: adds a timestamp prefix to a UUID-like value, so IDs sort roughly by creation time while staying compact and collision-resistant',
        'Snowflake ID: timestamp + machine/worker ID + per-millisecond counter — unique across machines with zero coordination needed, and naturally time-sortable',
        'Pick based on need: pure uniqueness with no ordering (UUID v4), sortable IDs for efficient indexing/pagination (Snowflake, ULID, UUID v7)',
      ],
    ),
    FundamentalConcept(
      id: 'back_of_envelope_estimation',
      category: 'IDs & Estimation',
      title: 'Back-of-the-Envelope Capacity Estimation',
      summary:
          'Before designing a system, rough napkin math on scale keeps the design honest: is this a '
          '10-requests-per-second problem or a 100,000-per-second one, because the right architecture is '
          'completely different at each end. Start from a stated or reasonable assumption (daily active '
          'users, actions per user per day), convert to requests per second, estimate storage growth per year '
          'from record size × record count, and sanity-check bandwidth and memory needs for a cache that '
          'could hold the hot working set. The exact numbers matter far less than the order of magnitude — '
          'the point is catching early on that, say, "the naive design needs 50 database round trips per '
          'request," not producing a defensible number to three significant figures.',
      keyPoints: [
        'Convert stated assumptions (DAU, actions/user/day) into requests/second — this single number drives most other architectural decisions (does it need a cache? sharding? a CDN?)',
        'Storage growth: record size × records/day × retention period gives a rough yearly storage figure, which tells you whether "a single database" is even plausible',
        'Read:write ratio matters as much as raw volume — a 100:1 read-heavy system (like most social apps) needs aggressive caching in a way a write-heavy system does not',
        'The goal is order-of-magnitude sanity-checking, not precision — round generously and move on once the estimate clearly rules in or out an approach',
      ],
    ),
    FundamentalConcept(
      id: 'requirements_gathering_tradeoffs',
      category: 'IDs & Estimation',
      title: 'Requirements Gathering & Trade-off Frameworks',
      summary:
          'Like cooking a new dish for a crowd, you ask who\'s eating and how many before you start chopping. '
          'The standard interview flow starts with functional requirements (the specific features/use cases: '
          '"users can post," "users can follow"), then non-functional requirements (the "how well": expected '
          'scale/QPS, latency targets, consistency needs, availability targets) — before any capacity math or '
          'architecture, because those numbers are exactly what capacity estimation and architecture '
          'decisions depend on. Every design also involves trade-offs, and being explicit about them — "I\'m '
          'choosing eventual consistency here because availability matters more than millisecond-fresh reads '
          'for this feature" — is what separates a senior-level answer from a list of technologies with no '
          'reasoning connecting them to the actual requirements.',
      keyPoints: [
        'Functional requirements first: the concrete features/use cases the system must support — restate the problem in your own words to confirm you understood it',
        'Non-functional requirements next: scale (DAU/QPS), latency targets, consistency model, availability target, durability — these numbers drive every later decision',
        'State assumptions out loud rather than silently guessing — an interviewer (or a real stakeholder) can correct a stated assumption; they can\'t correct one they never heard',
        'Every architectural choice is a trade-off — explicitly naming what you\'re optimizing for and what you\'re giving up is what turns a list of components into an actual design',
        'Build so today\'s decisions don\'t force an unnecessary teardown later, but don\'t over-engineer for scale that may never arrive — decide what to build first vs. defer explicitly',
      ],
    ),
  ];
}
