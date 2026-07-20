import '../models/quiz_question.dart';

/// Quiz questions for the System Design Fundamentals theory concepts,
/// keyed by [FundamentalConcept.id]. Mirrors the shape of QuizData for DSA
/// algorithms, but 5 questions per concept rather than 15 — these check
/// understanding of a single theory topic rather than tracing a multi-step
/// procedural algorithm.
class FundamentalsQuizData {
  static List<QuizQuestion> questionsFor(String conceptId) {
    return _bank[conceptId] ?? const [];
  }

  static final Map<String, List<QuizQuestion>> _bank = {
    'dns_request_routing': _dnsRequestRouting,
    'tcp_vs_udp': _tcpVsUdp,
    'websockets_long_polling': _websocketsLongPolling,
    'rest_vs_graphql_vs_grpc': _restVsGraphqlVsGrpc,
    'idempotency': _idempotency,
    'load_balancer_layers': _loadBalancerLayers,
    'caching_strategies': _cachingStrategies,
    'cdn_edge_caching': _cdnEdgeCaching,
    'sql_vs_nosql': _sqlVsNosql,
    'acid_vs_base': _acidVsBase,
    'indexing': _indexing,
    'replication': _replication,
    'sharding_partitioning': _shardingPartitioning,
    'geo_replication': _geoReplication,
    'horizontal_vs_vertical_scaling': _horizontalVsVerticalScaling,
    'stateless_services': _statelessServices,
    'cap_theorem': _capTheorem,
    'eventual_consistency_quorum': _eventualConsistencyQuorum,
    'consensus_leader_election': _consensusLeaderElection,
    'message_queues': _messageQueues,
    'pub_sub': _pubSub,
    'batch_vs_stream_processing': _batchVsStreamProcessing,
    'rate_limiting_algorithms': _rateLimitingAlgorithms,
    'object_storage': _objectStorage,
    'authn_authz': _authnAuthz,
    'search_full_text_indexing': _searchFullTextIndexing,
    'push_notifications_fanout': _pushNotificationsFanout,
    'geospatial_indexing': _geospatialIndexing,
  };

  static const _dnsRequestRouting = [
    QuizQuestion(
      question: 'What does DNS resolve a hostname like "api.example.com" into?',
      options: ['A database schema', 'An IP address', 'A TCP port number', 'A TLS certificate'],
      correctIndex: 1,
      explanation: 'DNS is the internet\'s phonebook, mapping human-readable domains to IP addresses.',
    ),
    QuizQuestion(
      question: 'Why is DNS resolution generally not considered part of the "hot path" for every request?',
      options: ['DNS servers are extremely slow, so it\'s avoided entirely', 'Resolved lookups are cached (via TTL) by the browser, OS, and ISP, so the lookup only happens occasionally', 'DNS is only used once per day by convention', 'Modern browsers skip DNS resolution entirely'],
      correctIndex: 1,
      explanation: 'Aggressive caching at multiple layers means most requests reuse a previously resolved IP.',
    ),
    QuizQuestion(
      question: 'What is a client\'s typical next step immediately after DNS resolves an IP address?',
      options: ['It opens a TCP connection to that IP, usually a load balancer rather than an individual server', 'It queries a second DNS server to double-check', 'It writes directly to the database', 'Nothing — the request is already complete'],
      correctIndex: 0,
      explanation: 'The resolved IP is typically a load balancer\'s address, which then routes to individual servers.',
    ),
    QuizQuestion(
      question: 'How can DNS itself contribute to coarse-grained load balancing or failover?',
      options: ['It cannot — DNS has no role in load balancing', 'By returning different IPs for the same hostname, e.g. round-robin DNS or geo-routing to the nearest region', 'By caching database query results', 'By compressing HTTP responses'],
      correctIndex: 1,
      explanation: 'Round-robin or geo-aware DNS answers can spread traffic or route users to a nearby region before any application-level load balancer is involved.',
    ),
    QuizQuestion(
      question: 'A DNS record\'s TTL was just lowered from 24 hours to 60 seconds ahead of a planned server migration. Why would an engineer do this?',
      options: ['To make DNS lookups faster', 'So that once the migration happens, clients pick up the new IP address quickly instead of continuing to use a stale cached one for up to a day', 'TTL has no effect on how long a resolved IP is cached', 'To reduce the cost of running DNS servers'],
      correctIndex: 1,
      explanation: 'A shorter TTL reduces how long clients might keep using an outdated cached IP after a cutover.',
    ),
  ];

  static const _tcpVsUdp = [
    QuizQuestion(
      question: 'Which transport protocol guarantees ordered, reliable delivery by retransmitting lost packets?',
      options: ['UDP', 'TCP', 'DNS', 'HTTP'],
      correctIndex: 1,
      explanation: 'TCP is connection-oriented and guarantees ordered, reliable delivery — the tradeoff is more overhead.',
    ),
    QuizQuestion(
      question: 'Why would a live video call typically use UDP instead of TCP?',
      options: ['UDP is more reliable than TCP', 'UDP has lower overhead and no retransmission delay, so occasional packet loss is preferable to the lag TCP\'s retransmission/ordering guarantees would introduce', 'TCP cannot carry audio or video data', 'UDP requires a more complex handshake'],
      correctIndex: 1,
      explanation: 'Real-time media favors low latency over perfect delivery — a dropped frame is less disruptive than a delayed one.',
    ),
    QuizQuestion(
      question: 'What is the interview default when a requirement doesn\'t explicitly call for real-time media or a reliability-for-latency tradeoff?',
      options: ['UDP, because it is always faster', 'TCP/HTTP, since correctness usually matters more than raw speed for APIs and web pages', 'Neither — use a proprietary protocol', 'It depends entirely on the programming language used'],
      correctIndex: 1,
      explanation: 'TCP/HTTP is the safe default for APIs and web traffic where reliability and ordering matter.',
    ),
    QuizQuestion(
      question: 'Which of the following does TCP require before either side can send application data?',
      options: ['A handshake to open the connection', 'A DNS lookup on every packet', 'Encrypting all data with TLS', 'A load balancer must be present'],
      correctIndex: 0,
      explanation: 'TCP performs a handshake to establish a connection before any data is exchanged.',
    ),
    QuizQuestion(
      question: 'Besides live video/voice calls, what other common use case relies on UDP rather than TCP?',
      options: ['Database transactions', 'DNS lookups', 'Credit card payment processing', 'Loading a web page\'s HTML'],
      correctIndex: 1,
      explanation: 'DNS lookups are typically short, latency-sensitive, and tolerant of an occasional retry, so they use UDP.',
    ),
  ];

  static const _websocketsLongPolling = [
    QuizQuestion(
      question: 'Why can\'t a server push data to a client using plain HTTP alone?',
      options: ['HTTP is too slow', 'Plain HTTP is request-response — the client always has to initiate before the server can respond', 'Servers are not allowed to send data', 'HTTP only supports text, not binary data'],
      correctIndex: 1,
      explanation: 'Regular HTTP requires the client to make the first move; the server can\'t spontaneously push without a different mechanism.',
    ),
    QuizQuestion(
      question: 'What makes WebSockets well-suited for a chat application?',
      options: ['They upgrade a single TCP connection into a persistent, full-duplex channel where either side can send at any time with low per-message overhead', 'They automatically translate messages between languages', 'They only work for static content', 'They eliminate the need for a server entirely'],
      correctIndex: 0,
      explanation: 'A persistent, bidirectional connection is ideal for the frequent, low-latency messages a chat app needs.',
    ),
    QuizQuestion(
      question: 'What is long polling?',
      options: ['A WebSocket variant', 'A plain HTTP request that the server holds open until it has data (or hits a timeout), after which the client immediately re-requests', 'A way to speed up DNS lookups', 'A database replication strategy'],
      correctIndex: 1,
      explanation: 'Long polling simulates server push using ordinary HTTP requests held open by the server.',
    ),
    QuizQuestion(
      question: 'When would Server-Sent Events (SSE) be preferred over a full WebSocket connection?',
      options: ['When the client needs to send large amounts of data to the server', 'When the server only ever needs to push data to the client and never receive anything back over that same channel', 'SSE is never actually a good choice', 'When the connection needs to work over UDP'],
      correctIndex: 1,
      explanation: 'SSE is a lighter one-way alternative to WebSockets, ideal for pure server-to-client push.',
    ),
    QuizQuestion(
      question: 'What capacity-planning consequence follows from holding many WebSocket or long-poll connections open at once?',
      options: ['None — connection count doesn\'t affect server resources', 'API servers need to be provisioned for high concurrent connection counts, not just high request throughput', 'It automatically reduces database load', 'It eliminates the need for a load balancer'],
      correctIndex: 1,
      explanation: 'Persistent connections consume server resources (memory, file descriptors) even while idle, which is a distinct capacity concern from request throughput.',
    ),
  ];

  static const _restVsGraphqlVsGrpc = [
    QuizQuestion(
      question: 'What is the core idea behind REST\'s design?',
      options: ['A system is modeled as resources (e.g. /users/123) manipulated with standard HTTP verbs', 'Every request must use a binary protocol', 'The client specifies exactly which fields it wants', 'It only works over UDP'],
      correctIndex: 0,
      explanation: 'REST is resource-oriented: URLs identify resources, and HTTP verbs (GET, POST, etc.) act on them.',
    ),
    QuizQuestion(
      question: 'What problem does GraphQL primarily solve compared to REST?',
      options: ['It makes servers run faster', 'It lets the client specify exactly the shape of data it wants in a single request, avoiding multiple round trips or over-fetching', 'It removes the need for a database', 'It only supports mobile clients'],
      correctIndex: 1,
      explanation: 'GraphQL\'s client-specified queries can satisfy complex, varying data needs in one round trip.',
    ),
    QuizQuestion(
      question: 'Why is gRPC typically the default choice for internal service-to-service calls rather than public-facing APIs?',
      options: ['It uses compact binary Protocol Buffers over HTTP/2 with strongly typed contracts, giving very low latency — but it\'s less universally accessible than plain HTTP/JSON for external clients', 'gRPC cannot be used publicly for legal reasons', 'It is slower than REST', 'It only works within a single programming language'],
      correctIndex: 0,
      explanation: 'gRPC\'s performance advantages shine internally, while REST\'s simplicity and universal HTTP support suit public APIs better.',
    ),
    QuizQuestion(
      question: 'Which of these is a known tradeoff of GraphQL compared to REST?',
      options: ['GraphQL is impossible to cache with standard HTTP caching and has more complex server-side query resolution', 'GraphQL cannot return nested data', 'GraphQL requires no server-side code at all', 'GraphQL only works with SQL databases'],
      correctIndex: 0,
      explanation: 'Because GraphQL requests are flexible queries rather than fixed resource URLs, standard HTTP caching (which relies on stable URLs) doesn\'t apply as cleanly.',
    ),
    QuizQuestion(
      question: 'In an interview, saying "REST from the mobile client, gRPC between internal services" demonstrates what?',
      options: ['Indecision about which technology to use', 'Real tradeoff awareness — picking the right protocol per traffic type (public-facing vs internal) instead of one-size-fits-all', 'A mistake, since only one protocol should ever be used', 'That gRPC is obsolete'],
      correctIndex: 1,
      explanation: 'Matching the protocol to the specific traffic pattern is a high-signal design decision in system design interviews.',
    ),
  ];

  static const _idempotency = [
    QuizQuestion(
      question: 'What does it mean for an operation to be idempotent?',
      options: ['It can only be performed once ever', 'Performing it multiple times has the same effect as performing it once', 'It always fails on the second attempt', 'It requires no network connection'],
      correctIndex: 1,
      explanation: 'Idempotency means repeated execution doesn\'t change the outcome beyond the first successful application.',
    ),
    QuizQuestion(
      question: 'Why does idempotency matter so much in distributed systems specifically?',
      options: ['It doesn\'t — it\'s only relevant to single-machine applications', 'Networks are unreliable: a client may not receive a response even though the server processed the request, so it retries — and a non-idempotent retry can cause duplicate side effects', 'It makes code easier to read', 'It is required by the HTTP specification for all requests'],
      correctIndex: 1,
      explanation: 'Retries are a normal response to network uncertainty, so making retried operations safe (idempotent) prevents things like double-charging.',
    ),
    QuizQuestion(
      question: 'Which HTTP methods are naturally idempotent by convention?',
      options: ['Only POST', 'GET, PUT, and DELETE', 'None of them', 'Only GET'],
      correctIndex: 1,
      explanation: 'GET, PUT, and DELETE are expected to be idempotent by HTTP convention; POST is not.',
    ),
    QuizQuestion(
      question: 'What is a common pattern for making a non-idempotent operation like "charge this card" safe to retry?',
      options: ['Never allow retries under any circumstances', 'The client generates a unique idempotency key per logical operation; the server stores which keys it has already processed and returns the cached result instead of redoing the work', 'Always process the request twice to confirm', 'Switch the operation from POST to GET'],
      correctIndex: 1,
      explanation: 'An idempotency key lets the server recognize and safely short-circuit a retried request.',
    ),
    QuizQuestion(
      question: 'What does idempotency enable as a safe default behavior for handling failures?',
      options: ['Ignoring all failed requests permanently', '"Just retry on failure" becomes safe instead of a data-corruption risk', 'Rolling back the entire database on every failure', 'Switching to a different server for every retry'],
      correctIndex: 1,
      explanation: 'Without idempotency, blind retries risk applying an operation\'s side effects more than once.',
    ),
  ];

  static const _loadBalancerLayers = [
    QuizQuestion(
      question: 'What does a Layer 4 (L4) load balancer route on?',
      options: ['URL path and cookies', 'IP address and port only, protocol-agnostic', 'The contents of the request body', 'DNS records'],
      correctIndex: 1,
      explanation: 'L4 load balancers operate at the transport layer, routing purely on IP/port without inspecting HTTP content.',
    ),
    QuizQuestion(
      question: 'When would you need a Layer 7 (L7) load balancer instead of L4?',
      options: ['Never — L4 always suffices', 'When routing decisions need to be based on HTTP content, like sending /api/* to one fleet and /static/* to another', 'When you only have one backend server', 'When you want the absolute lowest possible overhead'],
      correctIndex: 1,
      explanation: 'L7 load balancers understand HTTP, enabling path-based routing, A/B testing, and session affinity.',
    ),
    QuizQuestion(
      question: 'How does a load balancer help the system tolerate individual server failures?',
      options: ['It doesn\'t — server failures always cause an outage', 'Health checks let it detect failing backends and stop routing traffic to them', 'It automatically restarts failed servers', 'By storing a backup copy of every server'],
      correctIndex: 1,
      explanation: 'Health checks are what let a load balancer route around a backend that has stopped responding.',
    ),
    QuizQuestion(
      question: 'Which load balancing algorithm sends more traffic to servers with greater capacity?',
      options: ['Round robin', 'Least connections', 'Weighted', 'Random'],
      correctIndex: 2,
      explanation: 'Weighted algorithms assign traffic proportionally, sending more to higher-capacity servers.',
    ),
    QuizQuestion(
      question: 'What tradeoff does an L7 load balancer make in exchange for its routing flexibility?',
      options: ['It cannot perform health checks', 'A bit more processing overhead, since it must inspect and understand HTTP content rather than just IP/port', 'It only supports a single backend server', 'It requires abandoning DNS entirely'],
      correctIndex: 1,
      explanation: 'Understanding HTTP content costs more processing than L4\'s protocol-agnostic IP/port routing.',
    ),
  ];

  static const _cachingStrategies = [
    QuizQuestion(
      question: 'In the cache-aside pattern, what happens on a cache miss?',
      options: ['The request fails immediately', 'The app reads from the database and populates the cache for next time', 'The cache is cleared entirely', 'The database is bypassed permanently'],
      correctIndex: 1,
      explanation: 'Cache-aside has the application manage population: read the database on a miss, then write the result into the cache.',
    ),
    QuizQuestion(
      question: 'What is the key tradeoff of write-through caching compared to cache-aside?',
      options: ['Write-through never keeps the cache in sync', 'Write-through keeps the cache always in sync with the database, but every write pays the cost of updating both', 'Write-through is only usable for read-only systems', 'Write-through eliminates the need for a database'],
      correctIndex: 1,
      explanation: 'Write-through writes to both cache and database together, trading write latency for cache freshness.',
    ),
    QuizQuestion(
      question: 'What is the risk of write-back (write-behind) caching?',
      options: ['It has no risks and is strictly better than the alternatives', 'Writes go to the cache immediately and are flushed to the database later, so a cache failure before the flush can lose data', 'It requires no cache at all', 'It only works for read-heavy workloads'],
      correctIndex: 1,
      explanation: 'Write-back trades durability risk for write speed, since data isn\'t immediately persisted to the database.',
    ),
    QuizQuestion(
      question: 'What is the most common default eviction policy for deciding what to drop when a cache is full?',
      options: ['First In First Out (FIFO)', 'Random eviction', 'Least Recently Used (LRU)', 'Largest item first'],
      correctIndex: 2,
      explanation: 'LRU evicts the item that hasn\'t been accessed in the longest time, a good general-purpose default.',
    ),
    QuizQuestion(
      question: 'Why is cache invalidation considered one of the hardest problems in computer science?',
      options: ['Because caches are rarely used in practice', 'Because there always needs to be a clear plan for how stale entries get removed or expired, and getting this wrong silently serves outdated data', 'Because it requires specialized hardware', 'Because it can only be solved with machine learning'],
      correctIndex: 1,
      explanation: 'Without a solid invalidation strategy (like TTLs or explicit invalidation), caches silently serve stale data.',
    ),
  ];

  static const _cdnEdgeCaching = [
    QuizQuestion(
      question: 'What kind of content is the best fit for CDN caching?',
      options: ['Highly personalized, frequently-changing data', 'Content that\'s the same for every user and doesn\'t change often — static assets, images, video, public pages', 'Real-time chat messages', 'Database transaction results'],
      correctIndex: 1,
      explanation: 'CDNs excel at content that\'s identical across users and relatively stable, which can be cached and reused broadly.',
    ),
    QuizQuestion(
      question: 'What happens on a CDN cache miss?',
      options: ['The request simply fails', 'The edge node fetches from the origin, serves it, and caches it for subsequent nearby requests', 'The CDN shuts down', 'The client must retry from a different region'],
      correctIndex: 1,
      explanation: 'On a miss, the edge fetches once from the origin and then serves cached copies to nearby subsequent requests.',
    ),
    QuizQuestion(
      question: 'What two things does a CDN primarily reduce?',
      options: ['Database size and index count', 'Latency (physical distance to the user) and origin load (fewer requests reach the origin servers)', 'Encryption overhead and DNS lookups', 'API complexity and code size'],
      correctIndex: 1,
      explanation: 'Serving from a nearby edge node cuts both round-trip latency and traffic hitting origin servers.',
    ),
    QuizQuestion(
      question: 'Would a CDN typically cache a personalized "your account dashboard" page?',
      options: ['Yes, always', 'Generally no — personalized or highly dynamic responses usually bypass the CDN and go straight to the origin', 'Only if the user requests it twice', 'CDNs cannot serve HTML at all'],
      correctIndex: 1,
      explanation: 'Personalized content differs per user, so it doesn\'t benefit from (and usually bypasses) shared edge caching.',
    ),
    QuizQuestion(
      question: 'Where are CDN edge servers physically located relative to origin servers?',
      options: ['In the exact same data center as the origin', 'Distributed around the world, close to end users', 'Only in the country where the company is headquartered', 'CDNs have no physical infrastructure'],
      correctIndex: 1,
      explanation: 'CDNs distribute edge nodes globally so content can be served from near wherever the user is.',
    ),
  ];

  static const _sqlVsNosql = [
    QuizQuestion(
      question: 'What is a defining characteristic of SQL (relational) databases?',
      options: ['No schema of any kind', 'A fixed schema, support for complex joins across tables, and strong ACID guarantees', 'Data is always stored as flat key-value pairs', 'They cannot store relationships between entities'],
      correctIndex: 1,
      explanation: 'Relational databases enforce structure and offer strong consistency guarantees via ACID transactions.',
    ),
    QuizQuestion(
      question: 'Which NoSQL category is described as extremely fast for simple lookups by key, and a great fit for caching or session data?',
      options: ['Document stores', 'Wide-column stores', 'Key-value stores', 'Graph databases'],
      correctIndex: 2,
      explanation: 'Key-value stores (like Redis or DynamoDB) offer the simplest model, optimized for fast lookups by a single key.',
    ),
    QuizQuestion(
      question: 'Which NoSQL category is optimized for very high write throughput at scale, good for time-series and event data?',
      options: ['Document stores', 'Wide-column stores', 'Key-value stores', 'None of them'],
      correctIndex: 1,
      explanation: 'Wide-column stores (like Cassandra) are purpose-built for massive write throughput and horizontal scale.',
    ),
    QuizQuestion(
      question: 'What is the recommended interview framing for choosing between SQL and NoSQL?',
      options: ['Always default to whichever you\'re personally most familiar with', 'Pick based on access patterns and consistency needs first — "how will this data be queried?" should drive the choice', 'Always pick SQL regardless of requirements', 'The choice never actually matters'],
      correctIndex: 1,
      explanation: 'Access patterns and consistency requirements should drive the database choice, not familiarity alone.',
    ),
    QuizQuestion(
      question: 'A document store like MongoDB is best suited for what kind of data?',
      options: ['Strictly tabular data with a rigid, never-changing schema', 'Semi-structured, JSON-like records with a flexible or varying shape, like user profiles or content', 'Only numerical time-series data', 'Binary large objects like videos'],
      correctIndex: 1,
      explanation: 'Document stores are designed for flexible, nested data shapes that don\'t fit neatly into rigid tables.',
    ),
  ];

  static const _acidVsBase = [
    QuizQuestion(
      question: 'What does the "A" in ACID stand for?',
      options: ['Availability', 'Atomicity', 'Asynchrony', 'Authentication'],
      correctIndex: 1,
      explanation: 'Atomicity means a transaction either fully happens or fully doesn\'t — no partial application.',
    ),
    QuizQuestion(
      question: 'What does BASE stand for?',
      options: ['Basically Available, Soft state, Eventually consistent', 'Best Available, Strict Enforcement', 'Batch Async Streaming Engine', 'Backup, Availability, Security, Encryption'],
      correctIndex: 0,
      explanation: 'BASE is the looser consistency model many distributed NoSQL systems embrace, prioritizing availability.',
    ),
    QuizQuestion(
      question: 'For which kind of data would ACID guarantees be most important?',
      options: ['A social media feed\'s like count', 'Money, inventory counts, or anything where a half-applied write is unacceptable', 'A public blog\'s view counter', 'A cache of recently viewed items'],
      correctIndex: 1,
      explanation: 'Financial or inventory data typically cannot tolerate partial or inconsistent writes.',
    ),
    QuizQuestion(
      question: 'Is the choice between ACID and BASE a strict binary?',
      options: ['Yes, a system must be 100% one or the other', 'No — it\'s a spectrum; many systems mix both, e.g. ACID within a single shard and eventual consistency across shards or regions', 'ACID and BASE are unrelated to distributed systems', 'BASE is simply a stricter version of ACID'],
      correctIndex: 1,
      explanation: 'Real systems often combine both models at different scopes rather than picking one exclusively.',
    ),
    QuizQuestion(
      question: 'What does "Isolation" in ACID guarantee?',
      options: ['Data is encrypted at rest', 'Concurrent transactions don\'t interfere with each other', 'The database runs on isolated hardware', 'Only one user can access the database at a time'],
      correctIndex: 1,
      explanation: 'Isolation ensures that concurrently running transactions behave as if executed one at a time from each other\'s perspective.',
    ),
  ];

  static const _indexing = [
    QuizQuestion(
      question: 'What is a database index, structurally?',
      options: ['A full copy of the entire table', 'An auxiliary data structure (commonly a B-tree or hash table) built on one or more columns to speed up lookups', 'A caching layer separate from the database', 'A type of database backup'],
      correctIndex: 1,
      explanation: 'An index is a separate structure that lets the database avoid scanning every row to find matches.',
    ),
    QuizQuestion(
      question: 'Without an index, what is the time complexity of finding a row by a given column\'s value?',
      options: ['O(1)', 'O(log n)', 'O(n) — every row must be checked', 'O(n²)'],
      correctIndex: 2,
      explanation: 'Without an index, the database must scan the entire table (a full scan) to find matching rows.',
    ),
    QuizQuestion(
      question: 'What is the cost of adding an index to a column?',
      options: ['There is no cost — indexes are always free', 'It slows down writes (INSERT/UPDATE) on that column, since the index must be updated too, and takes extra storage', 'It makes reads slower', 'It requires switching to a NoSQL database'],
      correctIndex: 1,
      explanation: 'Every index adds write overhead and storage cost, even though it speeds up matching reads.',
    ),
    QuizQuestion(
      question: 'Which columns are the best candidates for indexing?',
      options: ['Every column in the table, without exception', 'The columns your queries actually filter or sort on, especially WHERE clauses and JOIN keys', 'Only columns with unique values', 'Columns that are never queried'],
      correctIndex: 1,
      explanation: 'Indexing should be driven by actual query patterns, not applied blanket across every column.',
    ),
    QuizQuestion(
      question: 'What does column order matter for in a composite (multi-column) index?',
      options: ['It has no effect', 'It determines which queries the index can efficiently serve — the index is most useful for queries filtering on a matching prefix of those columns', 'It only affects storage cost, not query performance', 'It determines the table\'s primary key automatically'],
      correctIndex: 1,
      explanation: 'A composite index\'s column order determines which query patterns it can actually accelerate.',
    ),
  ];

  static const _replication = [
    QuizQuestion(
      question: 'What are the two main reasons systems use database replication?',
      options: ['Reducing storage costs and simplifying schemas', 'Availability (if one node dies, others still have the data) and read scalability (reads can be spread across replicas)', 'Encrypting data and compressing it', 'Eliminating the need for backups'],
      correctIndex: 1,
      explanation: 'Replication protects against node failure and lets read traffic be distributed across multiple copies.',
    ),
    QuizQuestion(
      question: 'In the leader-follower replication model, where do writes go?',
      options: ['To any follower, chosen at random', 'To a single leader, which then propagates changes to follower replicas', 'To all nodes simultaneously with no coordination', 'Writes are not allowed in this model'],
      correctIndex: 1,
      explanation: 'A single leader receiving all writes avoids write conflicts, while followers scale out reads.',
    ),
    QuizQuestion(
      question: 'What is replication lag?',
      options: ['The time it takes to set up replication initially', 'The delay (milliseconds to seconds) between a write on the leader and that write appearing on a follower', 'A measure of database storage size', 'The time between scheduled backups'],
      correctIndex: 1,
      explanation: 'Followers can lag behind the leader, meaning a read from a follower might return stale data.',
    ),
    QuizQuestion(
      question: 'What is the tradeoff between synchronous and asynchronous replication?',
      options: ['There is no meaningful difference', 'Synchronous replication waits for followers to confirm before acknowledging a write (safer, slower); asynchronous doesn\'t wait (faster, riskier on leader failure)', 'Asynchronous replication is always safer', 'Synchronous replication requires no followers at all'],
      correctIndex: 1,
      explanation: 'Synchronous replication trades write latency for a stronger durability guarantee across replicas.',
    ),
    QuizQuestion(
      question: 'What happens when the leader in a leader-follower setup fails?',
      options: ['The entire system permanently loses write capability', 'A follower is promoted to become the new leader — this failover process is what gives the system high availability', 'All data is immediately lost', 'The database automatically switches to a different database engine'],
      correctIndex: 1,
      explanation: 'Promoting a follower to leader after a failure is the mechanism that provides high availability.',
    ),
  ];

  static const _shardingPartitioning = [
    QuizQuestion(
      question: 'What problem does sharding solve that replication alone cannot?',
      options: ['Sharding provides backups', 'Sharding splits data across many servers so systems can scale writes horizontally, not just reads', 'Sharding encrypts data at rest', 'Sharding eliminates the need for indexes'],
      correctIndex: 1,
      explanation: 'Replication copies the same data everywhere; sharding splits data into subsets across many servers, scaling write capacity.',
    ),
    QuizQuestion(
      question: 'What is the main downside of hash-based sharding?',
      options: ['It spreads data unevenly', 'It makes range queries across shards expensive, even though it spreads data evenly', 'It cannot be used with a shard key', 'It requires manual rebalancing after every write'],
      correctIndex: 1,
      explanation: 'Hashing the shard key evenly distributes data, but a range query might need to touch every shard.',
    ),
    QuizQuestion(
      question: 'What risk does range-based sharding carry that hash-based sharding avoids?',
      options: ['No risk — range-based sharding is strictly better', 'Uneven "hot" shards, since some key ranges may receive disproportionately more traffic than others', 'It cannot support range queries at all', 'It requires a single point of failure by design'],
      correctIndex: 1,
      explanation: 'Range-based sharding makes range queries easy but can concentrate load on specific shards.',
    ),
    QuizQuestion(
      question: 'What advantage does consistent hashing offer over naive modulo hashing when shards are added or removed?',
      options: ['It requires no hashing at all', 'It minimizes how much data has to move/rebalance when the number of shards changes', 'It guarantees zero downtime regardless of implementation', 'It only works for numeric shard keys'],
      correctIndex: 1,
      explanation: 'Consistent hashing limits data movement to a small fraction of keys when the shard count changes, unlike naive modulo hashing which reshuffles nearly everything.',
    ),
    QuizQuestion(
      question: 'What is described as the single biggest design decision when sharding a database?',
      options: ['Choosing the database vendor', 'Choosing a good shard key, since it determines cross-shard query and transaction cost', 'Deciding on a backup schedule', 'Picking a programming language for the API layer'],
      correctIndex: 1,
      explanation: 'The shard key choice directly determines how much cross-shard coordination (the main cost of sharding) is needed.',
    ),
  ];

  static const _geoReplication = [
    QuizQuestion(
      question: 'What are the two main reasons for geo-replicating data across regions?',
      options: ['Reducing the number of database columns and improving compression', 'Lower read latency for distant users and disaster recovery if an entire region goes down', 'Avoiding the need for any replication at all', 'Making the schema simpler'],
      correctIndex: 1,
      explanation: 'Geo-replication serves users faster from a nearby region and protects against a full regional outage.',
    ),
    QuizQuestion(
      question: 'In an active-passive geo-replication setup, where do writes go?',
      options: ['To whichever region is closest to the user', 'To a single region; other regions replicate for reads and failover', 'To all regions simultaneously with automatic conflict resolution', 'Writes are disabled entirely'],
      correctIndex: 1,
      explanation: 'Active-passive keeps writes simple (no conflicts) by funneling them all through one region, at the cost of latency for distant writers.',
    ),
    QuizQuestion(
      question: 'What new problem does active-active geo-replication introduce that active-passive avoids?',
      options: ['None — active-active is strictly simpler', 'Conflicting concurrent writes across regions must be resolved, using the same tools as any eventually-consistent system', 'It cannot support reads at all', 'It requires abandoning replication entirely'],
      correctIndex: 1,
      explanation: 'Accepting writes in multiple regions independently means concurrent conflicting writes need resolution (e.g. last-write-wins or CRDTs).',
    ),
    QuizQuestion(
      question: 'Why is cross-region replication lag measured in tens to hundreds of milliseconds fundamentally unavoidable?',
      options: ['It\'s a solvable software bug that will eventually be fixed', 'It\'s physics — the speed of light over long distances caps how fast data can travel between regions', 'It only happens with poorly written software', 'It only affects databases, not any other kind of data'],
      correctIndex: 1,
      explanation: 'Physical distance imposes a hard latency floor that no amount of software optimization can eliminate.',
    ),
    QuizQuestion(
      question: 'What is a common interview move to simplify geo-replication requirements?',
      options: ['Replicate everything globally regardless of need', 'Keep each user\'s/entity\'s source of truth pinned to one region and only replicate what genuinely needs to be global', 'Avoid using multiple regions entirely, even for a global product', 'Always choose active-active for every use case'],
      correctIndex: 1,
      explanation: 'Pinning data locality to one region where possible reduces latency, simplifies consistency, and can help with data-residency compliance.',
    ),
  ];

  static const _horizontalVsVerticalScaling = [
    QuizQuestion(
      question: 'What does vertical scaling mean?',
      options: ['Adding more machines', 'Making a single machine bigger — more CPU, RAM, faster disks', 'Splitting data across multiple databases', 'Adding a caching layer'],
      correctIndex: 1,
      explanation: 'Vertical scaling increases the resources of one existing machine rather than adding more machines.',
    ),
    QuizQuestion(
      question: 'What is a fundamental limitation of vertical scaling?',
      options: ['It has no limitations', 'It has a hard ceiling (there\'s a biggest machine you can buy) and remains a single point of failure', 'It always costs more than horizontal scaling', 'It cannot be used for databases'],
      correctIndex: 1,
      explanation: 'No matter how large a single machine gets, there\'s an eventual ceiling, and it\'s still one point of failure.',
    ),
    QuizQuestion(
      question: 'What does horizontal scaling require that vertical scaling doesn\'t?',
      options: ['Nothing — it works identically to vertical scaling', 'The system to be designed for it: statelessness, load balancing, and often data partitioning', 'A single, more powerful CPU', 'Abandoning all caching'],
      correctIndex: 1,
      explanation: 'Spreading load across many machines only works if the architecture supports it — hence the need for statelessness and load balancing.',
    ),
    QuizQuestion(
      question: 'What is the typical real-world scaling sequence for most systems?',
      options: ['Horizontal first, then vertical', 'Vertical first (cheap, no redesign), then horizontal once a single machine is outgrown', 'Only vertical scaling is ever used', 'Only horizontal scaling is ever used'],
      correctIndex: 1,
      explanation: 'Vertical scaling is the cheap first step; horizontal scaling comes once a single machine\'s ceiling is reached.',
    ),
    QuizQuestion(
      question: 'What does horizontal scaling offer that vertical scaling fundamentally cannot?',
      options: ['Lower cost in all cases', 'Near-unlimited headroom and fault tolerance, since load spreads across multiple machines', 'Simpler application code', 'The elimination of network latency'],
      correctIndex: 1,
      explanation: 'Because load is spread across many machines, horizontal scaling can grow much further and survives individual machine failure.',
    ),
  ];

  static const _statelessServices = [
    QuizQuestion(
      question: 'What defines a stateless service?',
      options: ['It never stores any data anywhere', 'It keeps no per-user session data in its own memory between requests — any server can handle any request', 'It only serves static files', 'It has no database connection'],
      correctIndex: 1,
      explanation: 'Statelessness means no server holds onto session data that only it knows about between requests.',
    ),
    QuizQuestion(
      question: 'Why is statelessness essential for horizontal scaling and load balancing to actually work?',
      options: ['It isn\'t essential — any architecture scales the same way', 'Because request N and N+1 for the same user can land on different servers behind a load balancer, and those servers can\'t rely on remembering anything locally', 'Because stateless services use less electricity', 'Because it eliminates the need for a database'],
      correctIndex: 1,
      explanation: 'If servers held session state locally, a user\'s requests would need to always hit the same server, breaking free load distribution.',
    ),
    QuizQuestion(
      question: 'Where does session state go in a stateless architecture?',
      options: ['It is discarded entirely', 'A shared store — a database or a fast shared cache — instead of individual server memory', 'It stays in the load balancer permanently', 'Each server keeps its own independent copy with no synchronization'],
      correctIndex: 1,
      explanation: 'Moving session state to a shared store lets any server access it, regardless of which server handled a previous request.',
    ),
    QuizQuestion(
      question: 'What does statelessness let you do freely?',
      options: ['Ignore all failures', 'Add or remove servers freely without losing anyone\'s session', 'Skip authentication', 'Avoid using a load balancer'],
      correctIndex: 1,
      explanation: 'Because no server uniquely holds session data, servers can be added or removed without disrupting active sessions.',
    ),
    QuizQuestion(
      question: 'What is the tradeoff of "sticky sessions" (always routing a user to the same server) as an alternative to full statelessness?',
      options: ['There is no tradeoff — it is strictly better', 'It works, but reintroduces a single point of failure per user and complicates load balancing', 'It makes servers completely interchangeable', 'It is required for all modern web applications'],
      correctIndex: 1,
      explanation: 'Sticky sessions avoid moving state, but at the cost of the same server-affinity problems statelessness was meant to eliminate.',
    ),
  ];

  static const _capTheorem = [
    QuizQuestion(
      question: 'What are the three properties in the CAP theorem?',
      options: ['Consistency, Availability, Partition tolerance', 'Caching, Authentication, Persistence', 'Concurrency, Atomicity, Performance', 'Compression, Availability, Precision'],
      correctIndex: 0,
      explanation: 'CAP stands for Consistency, Availability, and Partition tolerance.',
    ),
    QuizQuestion(
      question: 'Why is partition tolerance treated as effectively mandatory rather than optional?',
      options: ['It isn\'t actually necessary for any system', 'Network partitions are a fact of life in any real distributed system, so the real-world choice is between consistency and availability during a partition', 'Partition tolerance is only relevant to single-machine systems', 'Modern networks never experience partitions'],
      correctIndex: 1,
      explanation: 'Since partitions will happen, the meaningful design choice is really C vs A, not whether to have P.',
    ),
    QuizQuestion(
      question: 'What does a CP (consistency-favoring) system do during a network partition?',
      options: ['It answers every request regardless of correctness', 'It refuses requests it can\'t guarantee are consistent, e.g. a bank ledger', 'It deletes all data', 'It ignores the partition entirely'],
      correctIndex: 1,
      explanation: 'CP systems prioritize correctness, returning an error rather than risking stale or conflicting data.',
    ),
    QuizQuestion(
      question: 'What does an AP (availability-favoring) system do during a network partition?',
      options: ['It shuts down completely', 'It keeps serving reads/writes with eventual reconciliation, favoring uptime — e.g. a social media feed or shopping cart', 'It only accepts read requests, never writes', 'It requires manual intervention to continue'],
      correctIndex: 1,
      explanation: 'AP systems stay available even if that means serving potentially stale data, betting that uptime matters more for that use case.',
    ),
    QuizQuestion(
      question: 'What is considered high-signal behavior in a system design interview regarding CAP?',
      options: ['Avoiding the topic entirely', 'Stating which side of CAP your design leans on for a given data path, and justifying it against the actual requirement', 'Insisting a system can have all three properties simultaneously', 'Only discussing CAP for read-only systems'],
      correctIndex: 1,
      explanation: 'Explicitly reasoning about the C vs A tradeoff per data path, tied to the actual requirement, demonstrates real understanding.',
    ),
  ];

  static const _eventualConsistencyQuorum = [
    QuizQuestion(
      question: 'What does eventual consistency guarantee?',
      options: ['Every read always returns the latest write instantly', 'If no new writes come in, all replicas will eventually converge to the same value, though they may disagree at any given instant', 'Data is never replicated', 'Writes are never accepted'],
      correctIndex: 1,
      explanation: 'Eventual consistency accepts temporary disagreement between replicas in exchange for availability and speed.',
    ),
    QuizQuestion(
      question: 'In a quorum system with N replicas, what does choosing W + R > N guarantee?',
      options: ['Nothing meaningful', 'Every read overlaps with the most recent write, giving strong consistency without needing every single replica to respond', 'That writes are never confirmed', 'That the system becomes fully unavailable'],
      correctIndex: 1,
      explanation: 'When write and read quorums overlap (W + R > N), at least one replica in any read set has seen the latest write.',
    ),
    QuizQuestion(
      question: 'What does eventual consistency trade away in exchange for availability and speed?',
      options: ['Nothing — there is no tradeoff', '"Always up to date" — reads may briefly return stale data', 'The ability to ever write data', 'The need for a network connection'],
      correctIndex: 1,
      explanation: 'Eventual consistency accepts short-term staleness as the price for staying available and fast.',
    ),
    QuizQuestion(
      question: 'What is "last-write-wins" as a conflict resolution strategy?',
      options: ['A complex cryptographic algorithm', 'A simple approach where the most recent write (by timestamp) overwrites earlier ones, which can silently lose data', 'A method that always keeps every conflicting write', 'A strategy used only for read operations'],
      correctIndex: 1,
      explanation: 'Last-write-wins is simple to implement but can silently discard a concurrent write that "loses" the timestamp comparison.',
    ),
    QuizQuestion(
      question: 'How do quorum reads/writes compare to picking a fully strict or fully loose consistency model?',
      options: ['They offer no meaningful middle ground', 'They let you dial in a specific consistency/availability/latency tradeoff between the two extremes', 'They are only usable in single-node systems', 'They eliminate the need for replication'],
      correctIndex: 1,
      explanation: 'Adjusting W and R lets a system tune its position on the consistency-availability spectrum rather than picking an extreme.',
    ),
  ];

  static const _consensusLeaderElection = [
    QuizQuestion(
      question: 'What do consensus algorithms like Raft and Paxos let a cluster of nodes do?',
      options: ['Encrypt data automatically', 'Agree on a single value or decision even when some nodes fail or messages are delayed or lost', 'Increase database storage capacity', 'Cache frequently accessed data'],
      correctIndex: 1,
      explanation: 'Consensus algorithms provide agreement despite node failures or unreliable message delivery.',
    ),
    QuizQuestion(
      question: 'In Raft\'s leader-based model, what does the elected leader do?',
      options: ['Nothing — Raft has no leader concept', 'Sequences all writes and replicates them to followers, only committing once a majority acknowledge', 'Stores a completely separate copy of the data with no coordination', 'Only handles read requests, never writes'],
      correctIndex: 1,
      explanation: 'The leader is responsible for ordering and replicating writes, with commits requiring majority acknowledgment.',
    ),
    QuizQuestion(
      question: 'Why must a majority ("quorum") of nodes agree before something is considered durable?',
      options: ['It\'s an arbitrary rule with no real purpose', 'It lets the system tolerate a minority of node failures without losing data or electing two conflicting leaders (split brain)', 'It makes the system slower for no benefit', 'It only matters for read operations'],
      correctIndex: 1,
      explanation: 'Requiring majority agreement prevents a minority partition from making conflicting decisions independently.',
    ),
    QuizQuestion(
      question: 'Besides consensus protocols themselves, where else does leader election commonly show up in system design?',
      options: ['Nowhere else — it\'s exclusive to Raft/Paxos', 'Promoting a standby database replica after the primary fails, or picking one instance among identical workers to run a singleton scheduled task', 'Only in client-side JavaScript code', 'Only in encryption algorithms'],
      correctIndex: 1,
      explanation: 'The same "pick exactly one coordinator" pattern applies to database failover and singleton job scheduling.',
    ),
    QuizQuestion(
      question: 'What is the latency cost of strong consensus?',
      options: ['There is no latency cost', 'Every committed write needs a round trip to a majority of nodes, which is why it\'s reserved for decisions that truly need it', 'It only affects read operations, never writes', 'It eliminates the need for any network communication'],
      correctIndex: 1,
      explanation: 'Requiring majority round trips for every commit is expensive, so consensus is used selectively (leader election, config, locks) rather than for every write.',
    ),
  ];

  static const _messageQueues = [
    QuizQuestion(
      question: 'What problem does a message queue solve?',
      options: ['It speeds up database queries', 'It decouples the service producing work from the service processing it, so the API server doesn\'t have to do slow work inline', 'It replaces the need for a database', 'It encrypts data in transit'],
      correctIndex: 1,
      explanation: 'A queue lets the API respond immediately while a separate worker processes the actual work asynchronously.',
    ),
    QuizQuestion(
      question: 'How does a message queue help absorb a sudden traffic spike?',
      options: ['It rejects all requests during a spike', 'The queue buffers the burst, and workers drain it at their own steady pace', 'It automatically adds more database capacity', 'It has no effect on traffic spikes'],
      correctIndex: 1,
      explanation: 'Queues smooth bursty traffic by letting workers process at a steady rate instead of being overwhelmed instantly.',
    ),
    QuizQuestion(
      question: 'What delivery guarantee decision must a message queue design account for?',
      options: ['None — all queues guarantee exactly-once delivery automatically', 'At-least-once (possible duplicates, needs idempotent consumers) vs at-most-once (possible silent loss)', 'Only whether the queue is public or private', 'Whether the queue uses SQL or NoSQL'],
      correctIndex: 1,
      explanation: 'Real-world queues typically offer at-least-once or at-most-once semantics, each with different failure implications.',
    ),
    QuizQuestion(
      question: 'What kind of work is a good fit for a message queue?',
      options: ['Anything the user is actively waiting to see in the response', 'Work that doesn\'t need to block the user\'s response — notifications, thumbnail generation, analytics events, order fulfillment steps', 'Only database schema migrations', 'Only work that must complete synchronously'],
      correctIndex: 1,
      explanation: 'Queues are ideal for deferred work where the user doesn\'t need to wait for completion.',
    ),
    QuizQuestion(
      question: 'How does a message queue isolate failures?',
      options: ['It doesn\'t — a crashing worker takes down the whole system', 'A slow or crashing worker doesn\'t take down the API, since the API only needs the queue to be up, not the worker', 'By duplicating every request to multiple databases', 'By removing the need for any error handling'],
      correctIndex: 1,
      explanation: 'Because producer and consumer are decoupled, a struggling worker doesn\'t directly impact the API\'s availability.',
    ),
  ];

  static const _pubSub = [
    QuizQuestion(
      question: 'How does pub-sub differ from a plain message queue?',
      options: ['There is no difference', 'One event can fan out to many independent subscribers, rather than being consumed by just one worker', 'Pub-sub cannot be used for asynchronous processing', 'Pub-sub requires a database, while queues do not'],
      correctIndex: 1,
      explanation: 'Pub-sub broadcasts one event to potentially many subscribers, unlike a queue where each message typically goes to one consumer.',
    ),
    QuizQuestion(
      question: 'In pub-sub, does a publisher need to know who is subscribed to a topic?',
      options: ['Yes, it must know every subscriber explicitly', 'No — it emits an event without knowing or caring who\'s listening', 'Only if there is exactly one subscriber', 'Publishers and subscribers must be the same service'],
      correctIndex: 1,
      explanation: 'Publishers are decoupled from subscribers; they simply emit to a topic.',
    ),
    QuizQuestion(
      question: 'What kind of scenario is pub-sub the natural fit for?',
      options: ['A single event needing exactly one predictable reaction', 'One event (e.g. "order placed") needing to trigger several unrelated reactions — confirmation email, inventory update, analytics — without those reactions coupling to each other', 'Only synchronous request-response APIs', 'Storing large binary files'],
      correctIndex: 1,
      explanation: 'Multiple independent, unrelated reactions to a single event is exactly what pub-sub decouples cleanly.',
    ),
    QuizQuestion(
      question: 'What architectural style is pub-sub a common building block for?',
      options: ['Monolithic, tightly-coupled architectures', 'Event-driven architectures, where services react to events rather than calling each other directly', 'Purely synchronous request-response systems only', 'Systems with no need for decoupling'],
      correctIndex: 1,
      explanation: 'Pub-sub enables services to react to events independently instead of making direct, tightly-coupled calls.',
    ),
    QuizQuestion(
      question: 'What benefit does the publisher/subscriber decoupling in pub-sub provide?',
      options: ['It makes services harder to deploy independently', 'It keeps services loosely coupled and independently deployable', 'It requires all services to share the same codebase', 'It removes the need for any messaging infrastructure'],
      correctIndex: 1,
      explanation: 'Because publishers and subscribers don\'t know about each other, they can be developed and deployed independently.',
    ),
  ];

  static const _batchVsStreamProcessing = [
    QuizQuestion(
      question: 'What is batch processing?',
      options: ['Processing each event the instant it arrives', 'Processing a large, bounded chunk of accumulated data on a schedule, like a nightly ETL job', 'A synonym for stream processing', 'A caching technique'],
      correctIndex: 1,
      explanation: 'Batch processing operates on accumulated data at scheduled intervals rather than continuously.',
    ),
    QuizQuestion(
      question: 'What does stream processing require that batch processing typically doesn\'t need to worry about as much?',
      options: ['Nothing extra — they are identical', 'Windowing (grouping events into time buckets) to handle events that arrive out of order or late', 'A relational database', 'A load balancer'],
      correctIndex: 1,
      explanation: 'Since stream events arrive continuously and can be out of order, windowing is needed to group and process them correctly.',
    ),
    QuizQuestion(
      question: 'What is the main appeal of stream processing over batch?',
      options: ['It is always cheaper to operate', 'Near-real-time insight — enabling features like live dashboards or fraud detection', 'It requires no infrastructure at all', 'It eliminates the need for any storage'],
      correctIndex: 1,
      explanation: 'Stream processing trades operational complexity for much lower latency between an event happening and it being reflected.',
    ),
    QuizQuestion(
      question: 'What is a Lambda architecture in this context?',
      options: ['A cloud provider\'s function-as-a-service product', 'Running both a fast-but-approximate streaming path and a slower, exact batch path over the same data, letting batch periodically correct the streaming view', 'A single-threaded processing model', 'A type of database index'],
      correctIndex: 1,
      explanation: 'Lambda architecture combines both approaches: streaming for immediacy, batch for eventual correctness.',
    ),
    QuizQuestion(
      question: 'What is the recommended default when choosing between batch and stream processing?',
      options: ['Always choose streaming, regardless of requirements', 'Default to batch unless the product genuinely needs sub-second freshness, since streaming infrastructure is a real operational cost', 'Always choose batch, even for real-time fraud detection', 'The choice never matters for system design'],
      correctIndex: 1,
      explanation: 'Streaming\'s added complexity should be justified by an actual sub-second freshness requirement, not adopted by default.',
    ),
  ];

  static const _rateLimitingAlgorithms = [
    QuizQuestion(
      question: 'What problem does rate limiting protect a system from?',
      options: ['Slow database queries', 'Being overwhelmed by abusive clients, buggy retries, or more legitimate traffic than it can handle', 'Running out of disk space', 'Incorrect DNS records'],
      correctIndex: 1,
      explanation: 'Rate limiting caps how many requests a client can make in a given window to protect system capacity.',
    ),
    QuizQuestion(
      question: 'What does the token bucket algorithm naturally allow?',
      options: ['No requests ever', 'Short bursts up to the bucket size, since tokens refill at a steady rate and each request consumes one', 'Only exactly one request per second, with zero flexibility', 'Unlimited requests at all times'],
      correctIndex: 1,
      explanation: 'Token bucket permits controlled bursts as long as tokens have accumulated, unlike a strictly steady-rate limiter.',
    ),
    QuizQuestion(
      question: 'What is the known flaw of a fixed window counter rate limiter?',
      options: ['It is impossible to implement', 'It can allow up to 2x the intended limit right at a window boundary', 'It never allows any requests', 'It requires no storage at all'],
      correctIndex: 1,
      explanation: 'A burst right at the edge of two adjacent fixed windows can slip through both windows\' limits.',
    ),
    QuizQuestion(
      question: 'How does a sliding window counter improve on the fixed window approach?',
      options: ['It doesn\'t — it\'s strictly worse', 'It fixes the boundary-burst problem, at the cost of a bit more bookkeeping', 'It removes the need for any counting at all', 'It only works for a single client'],
      correctIndex: 1,
      explanation: 'By tracking a rolling window instead of fixed buckets, sliding window avoids the edge-case burst allowance.',
    ),
    QuizQuestion(
      question: 'Why must a rate limiter\'s counters live in a shared, fast store rather than in each API server\'s local memory?',
      options: ['Local memory is always faster and should be preferred', 'So the limit holds correctly across many API server instances behind a load balancer, rather than each server tracking its own separate count', 'Shared stores are required by law', 'It has no effect on correctness'],
      correctIndex: 1,
      explanation: 'If each server tracked counts locally, a client could exceed the intended limit simply by being routed to different servers.',
    ),
  ];

  static const _objectStorage = [
    QuizQuestion(
      question: 'What kind of content is object storage (like S3) designed for?',
      options: ['Small, frequently-updated rows of structured data', 'Large, unstructured blobs like images, videos, backups, and log files', 'Real-time chat messages', 'Database transaction logs only'],
      correctIndex: 1,
      explanation: 'Object storage is built for large binary content addressed by a key, not structured relational rows.',
    ),
    QuizQuestion(
      question: 'What access pattern is object storage optimized for?',
      options: ['Fast random access and frequent partial updates', 'Writing or reading a whole object at a time, prioritizing massive scale and durability', 'Millisecond-level transactional updates to individual bytes', 'In-place editing of small portions of a file'],
      correctIndex: 1,
      explanation: 'Object storage typically handles whole-object reads/writes rather than fine-grained partial updates.',
    ),
    QuizQuestion(
      question: 'What should a relational database store for a large file like a video, instead of the file\'s raw bytes?',
      options: ['The full binary content, directly in a table column', 'A reference (a URL or key) pointing to where the object lives in object storage', 'Nothing at all — large files should never be tracked', 'A compressed version of the entire file'],
      correctIndex: 1,
      explanation: 'Keeping large blobs out of the database (storing only a reference) keeps the database fast and small.',
    ),
    QuizQuestion(
      question: 'What is object storage often paired with for frequently-accessed public objects?',
      options: ['A relational database index', 'A CDN', 'A message queue', 'A rate limiter'],
      correctIndex: 1,
      explanation: 'A CDN in front of object storage serves popular objects from edge locations, reducing latency and origin load.',
    ),
    QuizQuestion(
      question: 'What durability characteristic does object storage typically offer?',
      options: ['Single-copy storage with no redundancy', 'Very high durability, with data replicated across multiple locations, plus nearly infinite horizontal scalability', 'It guarantees data loss after 30 days', 'It only works within a single data center with no replication'],
      correctIndex: 1,
      explanation: 'Object storage systems replicate data across locations to achieve very high durability at massive scale.',
    ),
  ];

  static const _authnAuthz = [
    QuizQuestion(
      question: 'What question does authentication (AuthN) answer?',
      options: ['"What are you allowed to do?"', '"Who are you?"', '"How fast is the network?"', '"Where is the data stored?"'],
      correctIndex: 1,
      explanation: 'Authentication verifies identity — confirming who the caller is.',
    ),
    QuizQuestion(
      question: 'What question does authorization (AuthZ) answer?',
      options: ['"Who are you?"', '"What are you allowed to do?"', '"What is your IP address?"', '"How long has the session been open?"'],
      correctIndex: 1,
      explanation: 'Authorization checks a known identity against permissions for a specific action.',
    ),
    QuizQuestion(
      question: 'Can a user be authenticated but still unauthorized for a specific action?',
      options: ['No, authentication and authorization are the same thing', 'Yes — being logged in doesn\'t mean you\'re allowed to, say, delete someone else\'s account', 'Only if the user is an administrator', 'This scenario is impossible by design'],
      correctIndex: 1,
      explanation: 'AuthN and AuthZ are separate concerns; a logged-in user can still lack permission for a particular action.',
    ),
    QuizQuestion(
      question: 'What is a key tradeoff of JWTs compared to server-side session tokens?',
      options: ['JWTs require a database lookup on every request, unlike sessions', 'JWTs are self-contained and need no server-side lookup to validate, but immediate revocation is harder', 'JWTs cannot hold any identity information', 'Session tokens are always faster to validate than JWTs'],
      correctIndex: 1,
      explanation: 'JWTs avoid a server-side lookup for validation, at the cost of being harder to revoke instantly since the token itself remains valid until it expires.',
    ),
    QuizQuestion(
      question: 'Where should authorization checks be placed?',
      options: ['Only at the login endpoint', 'On every protected endpoint, not just at login — "logged in" is not the same as "allowed to do this specific thing"', 'Only in the frontend JavaScript code', 'Authorization checks are optional if TLS is used'],
      correctIndex: 1,
      explanation: 'Authorization must be checked per protected action, since being authenticated doesn\'t grant blanket permission.',
    ),
  ];

  static const _searchFullTextIndexing = [
    QuizQuestion(
      question: 'Why can\'t a normal relational index efficiently answer "which documents contain this word"?',
      options: ['Relational indexes are built for exact-match and range queries on a column, not free-text search across content', 'Relational databases cannot store text at all', 'This query type is impossible for any system', 'Normal indexes are actually perfectly suited for this'],
      correctIndex: 0,
      explanation: 'Free-text search needs a different data structure than the exact-match/range-optimized structures behind typical database indexes.',
    ),
    QuizQuestion(
      question: 'What is an inverted index?',
      options: ['A database backup format', 'A map from each term to the list of documents that contain it — the core structure behind search engines like Elasticsearch', 'A type of database replication', 'An index sorted in reverse alphabetical order'],
      correctIndex: 1,
      explanation: 'Inverted indexes map terms to the documents containing them, enabling fast free-text lookups.',
    ),
    QuizQuestion(
      question: 'What does relevance ranking (like TF-IDF or BM25) add on top of an inverted index?',
      options: ['Nothing — it\'s purely cosmetic', 'It scores matches by how well they fit the query, not just whether they match, surfacing the best results first', 'It removes documents from the index permanently', 'It only works for numeric data'],
      correctIndex: 1,
      explanation: 'Relevance ranking is what makes search results feel "smart" by ordering by quality of match, not just presence.',
    ),
    QuizQuestion(
      question: 'Is the search index typically the source of truth for the underlying data?',
      options: ['Yes, always', 'No — it\'s a derived, read-optimized copy kept in sync asynchronously with the primary database, so results can lag slightly', 'The search index and database are always the exact same system', 'Search indexes never need to be updated'],
      correctIndex: 1,
      explanation: 'Search indexes are derived copies, synced via mechanisms like change data capture, and can briefly lag the primary database.',
    ),
    QuizQuestion(
      question: 'When should a system reach for a dedicated search index instead of a normal database index?',
      options: ['For every single query, regardless of type', 'Specifically when the requirement is free-text, fuzzy, or ranked search — normal indexes already handle structured exact-match/range lookups', 'Never — dedicated search indexes are always unnecessary', 'Only for numeric range queries'],
      correctIndex: 1,
      explanation: 'A dedicated search index is justified when the query pattern genuinely needs free-text or relevance-ranked search.',
    ),
  ];

  static const _pushNotificationsFanout = [
    QuizQuestion(
      question: 'Why should notification generation never happen synchronously in the request that triggers it?',
      options: ['It\'s fine to do it synchronously in all cases', 'Fanning out to potentially millions of recipients is slow work that should be enqueued and handled asynchronously by a worker, following the same pattern as any async processing', 'Notifications don\'t need any backend processing', 'Synchronous notifications are required by push providers'],
      correctIndex: 1,
      explanation: 'Notification fan-out is exactly the kind of slow, non-blocking work that belongs in a queue rather than the request path.',
    ),
    QuizQuestion(
      question: 'What is fan-out-on-write?',
      options: ['Computing what each user sees only at read time', 'Precomputing and pushing the notification to every recipient\'s inbox at write time — fast reads, but wasteful for a hugely popular event', 'A method that never notifies anyone', 'A synchronous, blocking notification approach'],
      correctIndex: 1,
      explanation: 'Fan-out-on-write does the fan-out work upfront, trading write cost for fast reads later.',
    ),
    QuizQuestion(
      question: 'When would fan-out-on-read be preferable to fan-out-on-write?',
      options: ['Never — fan-out-on-write is always better', 'When an event might have a huge audience (e.g. a celebrity\'s post), since fan-out-on-read keeps writes cheap regardless of audience size at the cost of more expensive reads', 'Only for private, single-recipient messages', 'When the system has no read traffic at all'],
      correctIndex: 1,
      explanation: 'Fan-out-on-read avoids the wasted work of pushing to millions of inboxes upfront when few of them may ever check.',
    ),
    QuizQuestion(
      question: 'What role does a push provider (like APNs or FCM) play in notification delivery?',
      options: ['It has no role — the backend connects directly to every device', 'It maintains the actual connection to the device; the backend hands off delivery to the provider rather than holding that connection itself', 'It only works for web browsers, never mobile devices', 'It replaces the need for a message queue'],
      correctIndex: 1,
      explanation: 'Push providers manage the persistent device connections, so backends don\'t need to maintain them directly.',
    ),
    QuizQuestion(
      question: 'If a user already has an open WebSocket connection (e.g. an active chat screen), what is the better delivery path for a new message?',
      options: ['Always route through a push provider regardless of the open connection', 'Push directly over the existing live connection instead of round-tripping through a push provider', 'Wait for the user to close and reopen the app', 'Delivery is impossible in this case'],
      correctIndex: 1,
      explanation: 'An already-open live connection is a faster, more direct delivery path than going through an external push provider.',
    ),
  ];

  static const _geospatialIndexing = [
    QuizQuestion(
      question: 'Why can\'t a plain database index efficiently answer "what\'s within 2km of this point"?',
      options: ['Because databases cannot store coordinates', 'Proximity in 2D space isn\'t a value that sorts cleanly on a normal B-tree index', 'Because GPS coordinates are always inaccurate', 'Plain indexes actually handle this perfectly well'],
      correctIndex: 1,
      explanation: 'Spatial proximity needs a structure built for spatial locality, not a standard single-dimension sorted index.',
    ),
    QuizQuestion(
      question: 'What does geohashing do?',
      options: ['Encrypts location data for security', 'Encodes latitude/longitude into a single string where nearby points tend to share a prefix, turning proximity search into a prefix/range query', 'Compresses map image files', 'Converts coordinates into a database primary key with no spatial meaning'],
      correctIndex: 1,
      explanation: 'Geohashing\'s prefix-sharing property is what Redis\'s GEO commands use to make proximity search fast.',
    ),
    QuizQuestion(
      question: 'How do quadtrees and R-trees speed up proximity search?',
      options: ['They don\'t — they are unrelated to geospatial search', 'They recursively divide space into cells, so a query only searches cells near the target instead of scanning every point', 'They store all points in a single sorted list by name', 'They require pre-computing every possible distance in advance'],
      correctIndex: 1,
      explanation: 'Hierarchical spatial partitioning lets these structures prune away most of the space instead of checking every point.',
    ),
    QuizQuestion(
      question: 'What is Uber\'s H3, mentioned as a modern take on geospatial indexing?',
      options: ['A relational database engine', 'A hexagonal hierarchical grid system, commonly referenced in ride-sharing/delivery-style interview designs', 'A caching library', 'A message queue implementation'],
      correctIndex: 1,
      explanation: 'H3 divides the globe into a hexagonal hierarchical grid, a popular modern geospatial indexing approach.',
    ),
    QuizQuestion(
      question: 'Why does a high location-update frequency (like a driver\'s live GPS position) favor simpler, cheaper-to-update spatial structures?',
      options: ['Update frequency has no bearing on structure choice', 'Because these indexes need updating whenever a point moves, so frequent updates favor structures that are cheap to update over ones that are merely precise but expensive to maintain', 'Frequent updates make indexing unnecessary entirely', 'Only geohashing supports any updates at all'],
      correctIndex: 1,
      explanation: 'When positions change constantly, the cost of keeping the index up to date becomes a first-order concern, not just query speed.',
    ),
  ];
}
