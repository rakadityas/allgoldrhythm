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
    'oauth2_oidc_sso': _oauth2OidcSso,
    'jwt_and_sessions': _jwtAndSessions,
    'mfa_and_passwordless': _mfaAndPasswordless,
    'authorization_models': _authorizationModels,
    'encryption_at_rest_transit': _encryptionAtRestTransit,
    'secrets_management': _secretsManagement,
    'api_security_owasp': _apiSecurityOwasp,
    'network_security_zero_trust': _networkSecurityZeroTrust,
    'threat_modeling_stride': _threatModelingStride,
    'audit_logging_nonrepudiation': _auditLoggingNonrepudiation,
    'fintech_security_patterns': _fintechSecurityPatterns,
    'supply_chain_security': _supplyChainSecurity,
    'search_full_text_indexing': _searchFullTextIndexing,
    'push_notifications_fanout': _pushNotificationsFanout,
    'geospatial_indexing': _geospatialIndexing,
    'distributed_transactions_2pc_saga': _distributedTransactions2pcSaga,
    'gossip_protocol': _gossipProtocol,
    'vector_clocks_hlc': _vectorClocksHlc,
    'merkle_trees': _merkleTrees,
    'bloom_cuckoo_filters': _bloomCuckooFilters,
    'hyperloglog': _hyperloglog,
    'consistent_hashing': _consistentHashing,
    'btree_vs_lsm': _btreeVsLsm,
    'oltp_vs_olap': _oltpVsOlap,
    'data_warehouse_lake_lakehouse': _dataWarehouseLakeLakehouse,
    'change_data_capture': _changeDataCapture,
    'normalize_vs_denormalize': _normalizeVsDenormalize,
    'microservices_vs_monolith': _microservicesVsMonolith,
    'cqrs_event_sourcing': _cqrsEventSourcing,
    'circuit_breaker_bulkhead': _circuitBreakerBulkhead,
    'service_mesh_sidecar': _serviceMeshSidecar,
    'api_gateway_bff': _apiGatewayBff,
    'n_tier_thick_thin_client': _nTierThickThinClient,
    'strangler_fig_pattern': _stranglerFigPattern,
    'http_evolution': _httpEvolution,
    'grpc_protobuf': _grpcProtobuf,
    'webrtc_and_realtime': _webrtcAndRealtime,
    'retries_backoff_jitter': _retriesBackoffJitter,
    'delivery_semantics': _deliverySemantics,
    'health_checks_liveness_readiness': _healthChecksLivenessReadiness,
    'graceful_degradation_deploy_strategies': _gracefulDegradationDeployStrategies,
    'chaos_engineering': _chaosEngineering,
    'cascading_failures_thundering_herd': _cascadingFailuresThunderingHerd,
    'id_generation_snowflake_uuid': _idGenerationSnowflakeUuid,
    'back_of_envelope_estimation': _backOfEnvelopeEstimation,
    'requirements_gathering_tradeoffs': _requirementsGatheringTradeoffs,
    'erasure_coding_vs_replication': _erasureCodingVsReplication,
    'semantic_vector_search': _semanticVectorSearch,
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

  static const _oauth2OidcSso = [
    QuizQuestion(
      question: 'What does OAuth2 fundamentally let a user do?',
      options: ['Encrypt their password before sending it', 'Grant an application limited access to their data on another service, without sharing their password', 'Skip authentication entirely', 'Generate a TLS certificate'],
      correctIndex: 1,
      explanation: 'OAuth2 is a delegation protocol — "Sign in with Google" grants access without handing over credentials.',
    ),
    QuizQuestion(
      question: 'What does OIDC (OpenID Connect) add on top of plain OAuth2?',
      options: ['A faster network transport', 'An ID token (a JWT) that answers "who is this user," not just "what can this app do"', 'Password hashing', 'A rate limiter'],
      correctIndex: 1,
      explanation: 'OIDC is a thin identity layer over OAuth2, adding an ID token that describes the authenticated user.',
    ),
    QuizQuestion(
      question: 'Which OAuth2 flow is standard for web and mobile apps to prevent authorization code interception?',
      options: ['Client Credentials', 'Device Code', 'Authorization Code + PKCE', 'Implicit flow'],
      correctIndex: 2,
      explanation: 'PKCE adds a code verifier/challenge pair so an intercepted authorization code alone cannot be redeemed.',
    ),
    QuizQuestion(
      question: 'Which OAuth2 flow fits service-to-service authentication with no user involved?',
      options: ['Client Credentials', 'Authorization Code + PKCE', 'Device Code', 'SSO redirect'],
      correctIndex: 0,
      explanation: 'Client Credentials authenticates a service directly with a client ID and secret, no user in the loop.',
    ),
    QuizQuestion(
      question: 'What is SSO (Single Sign-On)?',
      options: ['A password strength requirement', 'Logging in once at a trusted identity provider and accessing many apps without re-authenticating', 'A type of database replication', 'A rate-limiting algorithm'],
      correctIndex: 1,
      explanation: 'SSO is the product of OAuth2/OIDC/SAML: one login, many downstream apps trust the same session.',
    ),
  ];

  static const _jwtAndSessions = [
    QuizQuestion(
      question: 'What is the key difference between a session token and a JWT?',
      options: ['They are functionally identical', 'A session token is opaque and stateful (server stores the data); a JWT is self-contained and stateless (the token carries the data)', 'JWTs cannot be signed', 'Session tokens cannot be stored in Redis'],
      correctIndex: 1,
      explanation: 'Session tokens require a server-side lookup; JWTs are self-contained and verifiable without one.',
    ),
    QuizQuestion(
      question: 'Why should secrets never be put in a JWT payload?',
      options: ['JWTs have a strict 100-byte size limit', 'The payload is base64-encoded, not encrypted — it is visible to anyone who has the token', 'JWTs are stored in plaintext on the server', 'It is technically impossible to add custom claims'],
      correctIndex: 1,
      explanation: 'A JWT payload is only encoded, not encrypted, so its contents are readable by anyone holding the token.',
    ),
    QuizQuestion(
      question: 'How is a JWT typically revoked before its natural expiry?',
      options: ['JWTs cannot be revoked under any circumstances', 'A jti blocklist (e.g. in Redis with a TTL) is checked after signature verification on each request', 'By changing the server\'s IP address', 'By restarting the API server'],
      correctIndex: 1,
      explanation: 'Since a JWT is otherwise valid until it expires, early revocation needs an explicit blocklist check.',
    ),
    QuizQuestion(
      question: 'What does refresh token rotation protect against?',
      options: ['Slow database queries', 'A stolen refresh token being reused — reuse of an already-rotated token is treated as a theft signal, revoking all tokens for that user', 'DNS cache poisoning', 'SQL injection'],
      correctIndex: 1,
      explanation: 'Issuing a new refresh token on every use and invalidating the old one turns reuse into a clear signal of compromise.',
    ),
    QuizQuestion(
      question: 'What is the fastest way to revoke a stateful session token immediately?',
      options: ['Wait for it to expire', 'DEL session:{token} in the shared session store', 'Rotate the server\'s TLS certificate', 'Restart the client application'],
      correctIndex: 1,
      explanation: 'Since stateful sessions are looked up server-side, deleting the stored session immediately invalidates it.',
    ),
  ];

  static const _mfaAndPasswordless = [
    QuizQuestion(
      question: 'Why use Argon2id or bcrypt instead of SHA256 for password storage?',
      options: ['SHA256 is not a real hashing algorithm', 'Argon2id/bcrypt are deliberately slow and memory-hard, making brute-forcing stolen hashes impractical, unlike fast general-purpose hashes like SHA256', 'SHA256 cannot process strings', 'There is no meaningful difference'],
      correctIndex: 1,
      explanation: 'Password hashing needs to be intentionally slow/memory-hard to resist brute-force attacks; general-purpose hashes like SHA256 are too fast for that.',
    ),
    QuizQuestion(
      question: 'What problem does a per-user salt solve?',
      options: ['It speeds up login', 'It defeats precomputed rainbow-table attacks and ensures identical passwords produce different stored hashes', 'It compresses the password for storage', 'It encrypts the network connection'],
      correctIndex: 1,
      explanation: 'A unique salt per user means two users with the same password get different hashes, and precomputed tables become useless.',
    ),
    QuizQuestion(
      question: 'Which MFA method is considered weakest due to SIM-swap attacks?',
      options: ['WebAuthn/FIDO2 hardware key', 'TOTP authenticator app', 'SMS OTP', 'Biometric fingerprint'],
      correctIndex: 2,
      explanation: 'An attacker who ports a victim\'s phone number to their own SIM can intercept SMS OTPs entirely.',
    ),
    QuizQuestion(
      question: 'What makes WebAuthn/FIDO2 phishing-resistant compared to a password or OTP?',
      options: ['It requires a longer password', 'It is origin-bound — the cryptographic credential only works with the legitimate site it was registered to, so a fake phishing site cannot use it', 'It sends a code via email', 'It disables the browser'],
      correctIndex: 1,
      explanation: 'WebAuthn credentials are cryptographically tied to the real origin, so they simply do not function against a spoofed site.',
    ),
    QuizQuestion(
      question: 'What is step-up authentication?',
      options: ['Requiring MFA on every single request', 'Re-authenticating or requiring an extra factor mid-session only when a sensitive action is triggered', 'A way to skip authentication for trusted IPs', 'A password complexity rule'],
      correctIndex: 1,
      explanation: 'Step-up auth adds friction only where risk is highest (e.g. a large transfer), rather than everywhere.',
    ),
  ];

  static const _authorizationModels = [
    QuizQuestion(
      question: 'What is RBAC (Role-Based Access Control)?',
      options: ['Permissions derived from a relationship graph', 'Roles assigned to users, permissions assigned to roles — coarse-grained and simple', 'A rule engine based on request attributes', 'A form of encryption'],
      correctIndex: 1,
      explanation: 'RBAC is the simplest model: users get roles, and roles carry a fixed set of permissions.',
    ),
    QuizQuestion(
      question: 'Which rule style is characteristic of ABAC?',
      options: ['"Anyone with the admin role can do anything"', '"Block if new_device AND amount > 10M AND hour > 22:00"', '"Users in the same folder share access"', '"All requests are denied by default forever"'],
      correctIndex: 1,
      explanation: 'ABAC evaluates conditions over attributes of the user, resource, and context, not just a fixed role.',
    ),
    QuizQuestion(
      question: 'When does ReBAC (Relationship-Based Access Control) fit best?',
      options: ['When permissions are graph-like — social graphs, nested folders, multi-tenant platforms', 'Only for single-user applications', 'When there is exactly one role in the system', 'It replaces the need for authentication entirely'],
      correctIndex: 0,
      explanation: 'ReBAC (the Google Zanzibar model) derives access from relationships, which suits graph-shaped permission structures.',
    ),
    QuizQuestion(
      question: 'What is OPA (Open Policy Agent) used for?',
      options: ['Encrypting data at rest', 'Running authorization rules as version-controlled, testable policy code, often as a sidecar', 'Generating TLS certificates', 'Load balancing traffic'],
      correctIndex: 1,
      explanation: 'OPA (using the Rego language) externalizes authorization logic into policy code that can be tested and deployed independently of the app.',
    ),
    QuizQuestion(
      question: 'Why start with RBAC even though it is coarse-grained?',
      options: ['It is the only model that works with HTTPS', 'It is simple to reason about and a good starting point, upgrading to ABAC/ReBAC only when fine-grained rules are actually needed', 'It requires no code at all', 'It automatically encrypts all data'],
      correctIndex: 1,
      explanation: 'RBAC covers most needs simply; more complex models add real value once requirements outgrow role-based checks.',
    ),
  ];

  static const _encryptionAtRestTransit = [
    QuizQuestion(
      question: 'What does forward secrecy (via ephemeral Diffie-Hellman) protect against in TLS?',
      options: ['Slow network speeds', 'A compromised private key later being used to decrypt previously captured traffic', 'DNS spoofing', 'Password reuse'],
      correctIndex: 1,
      explanation: 'Ephemeral session keys mean even a later-leaked long-term private key cannot decrypt past sessions.',
    ),
    QuizQuestion(
      question: 'What distinguishes mTLS from regular TLS?',
      options: ['mTLS does not use certificates at all', 'In mTLS, both the client and server present certificates, giving cryptographic identity to both sides', 'mTLS is slower but otherwise identical', 'mTLS only works over UDP'],
      correctIndex: 1,
      explanation: 'Regular TLS authenticates the server only; mTLS requires both sides to prove their identity.',
    ),
    QuizQuestion(
      question: 'In envelope encryption, what does rotating the Master Encryption Key (MEK) actually require?',
      options: ['Re-encrypting the entire dataset', 'Re-encrypting only the small Data Encryption Keys (DEKs), not all the underlying data', 'Nothing — MEKs cannot be rotated', 'Deleting all encrypted data'],
      correctIndex: 1,
      explanation: 'Since the MEK only ever encrypts DEKs (not data directly), rotation is cheap: only the DEKs need re-encrypting.',
    ),
    QuizQuestion(
      question: 'What is field-level encryption?',
      options: ['Encrypting every column in every table identically', 'Encrypting only specific sensitive columns (e.g. card numbers), while IDs and metadata stay queryable in plaintext', 'A network-layer encryption protocol', 'A type of database index'],
      correctIndex: 1,
      explanation: 'Field-level encryption targets sensitive columns specifically, keeping the rest of the row usable for normal queries.',
    ),
    QuizQuestion(
      question: 'What is the standard algorithm/mode for encrypting data at rest today?',
      options: ['MD5', 'AES-256-GCM (authenticated encryption)', 'Base64 encoding', 'ROT13'],
      correctIndex: 1,
      explanation: 'AES-GCM is both fast (with hardware acceleration) and authenticated, detecting tampering as well as providing confidentiality.',
    ),
  ];

  static const _secretsManagement = [
    QuizQuestion(
      question: 'What is the safest place for an API key or database password in source code?',
      options: ['Hardcoded directly in the source file', 'Committed to a private Git repo only', 'Nowhere — it should be fetched at runtime from a secrets manager, never hardcoded or committed', 'In a code comment for documentation'],
      correctIndex: 2,
      explanation: 'Secrets should never appear in source or Git history at all; a secrets manager should supply them at runtime.',
    ),
    QuizQuestion(
      question: 'What is a "dynamic secret" as implemented by tools like Vault?',
      options: ['A password that never changes', 'A fresh, unique credential generated per service instance with a short TTL, auto-revoked on expiry', 'A secret stored in a public S3 bucket', 'A hardcoded fallback password'],
      correctIndex: 1,
      explanation: 'Dynamic secrets avoid long-lived shared passwords by minting short-lived, per-instance credentials automatically.',
    ),
    QuizQuestion(
      question: 'Why is a leaked dynamic secret less dangerous than a leaked long-lived password?',
      options: ['Dynamic secrets are always encrypted twice', 'It has a short TTL and is auto-revoked, so it is only useful for a narrow window before expiring', 'Dynamic secrets cannot be used by attackers under any circumstance', 'It is not actually less dangerous'],
      correctIndex: 1,
      explanation: 'The short lifetime of a dynamic secret sharply limits how long a leaked credential remains useful.',
    ),
    QuizQuestion(
      question: 'What does secret rotation with a "grace period overlap" achieve?',
      options: ['It makes secrets permanent', 'It changes secrets regularly while keeping the old one valid briefly, avoiding downtime during the swap', 'It disables the secret entirely during rotation', 'It has nothing to do with availability'],
      correctIndex: 1,
      explanation: 'Overlapping validity between old and new secrets lets services roll over without a service interruption.',
    ),
    QuizQuestion(
      question: 'What role does a sidecar play in secrets management?',
      options: ['It encrypts network traffic only', 'It fetches and renews secrets on behalf of the app, so the app just reads a local file/env without talking to the secrets manager API directly', 'It stores secrets permanently in the container image', 'It replaces the need for TLS'],
      correctIndex: 1,
      explanation: 'A secrets sidecar handles the fetch/renew lifecycle, keeping secrets-manager integration out of the application code.',
    ),
  ];

  static const _apiSecurityOwasp = [
    QuizQuestion(
      question: 'What is BOLA (Broken Object Level Authorization)?',
      options: ['A network timeout error', 'Accessing another user\'s resource by guessing or changing an ID in the request, without an ownership check', 'A type of encryption algorithm', 'A load balancing strategy'],
      correctIndex: 1,
      explanation: 'BOLA, the #1 OWASP API risk, happens when an endpoint fetches a resource by ID without verifying it belongs to the caller.',
    ),
    QuizQuestion(
      question: 'How is BOLA typically fixed?',
      options: ['By encrypting the ID', 'By always scoping the query to the authenticated user, e.g. WHERE txn.user_id = auth.user_id, rather than trusting the path parameter alone', 'By using a longer ID format', 'By removing IDs from URLs entirely'],
      correctIndex: 1,
      explanation: 'The fix is enforcing ownership at the query level, never trusting a client-supplied ID by itself.',
    ),
    QuizQuestion(
      question: 'What prevents SQL injection?',
      options: ['String-concatenating user input carefully', 'Parameterized queries / prepared statements', 'Rate limiting', 'CORS headers'],
      correctIndex: 1,
      explanation: 'Parameterized queries separate code from data so user input can never be interpreted as SQL syntax.',
    ),
    QuizQuestion(
      question: 'What does a Content-Security-Policy header primarily defend against?',
      options: ['SQL injection', 'XSS (Cross-Site Scripting)', 'DNS spoofing', 'Password brute-forcing'],
      correctIndex: 1,
      explanation: 'CSP restricts which scripts can execute on a page, blocking most injected-script attacks.',
    ),
    QuizQuestion(
      question: 'What should be blocked to prevent SSRF (Server-Side Request Forgery)?',
      options: ['All outbound HTTPS traffic', 'Internal/private IP ranges (RFC 1918) and cloud metadata endpoints like 169.254.169.254', 'All incoming requests', 'Only requests from mobile devices'],
      correctIndex: 1,
      explanation: 'SSRF abuses a server\'s own network access, so requests to internal ranges and metadata endpoints need explicit blocking/validation.',
    ),
  ];

  static const _networkSecurityZeroTrust = [
    QuizQuestion(
      question: 'What is the core idea of "zero trust"?',
      options: ['Trust any request from inside the corporate network automatically', 'Never trust a request based on network location alone — authenticate and authorize every request, even internal service-to-service calls', 'Disable all authentication for speed', 'Only external requests need authentication'],
      correctIndex: 1,
      explanation: 'Zero trust removes the assumption that "internal" traffic is automatically safe.',
    ),
    QuizQuestion(
      question: 'What does a service mesh sidecar proxy (Istio/Linkerd) typically handle?',
      options: ['Compiling the application code', 'mTLS, retries, timeouts, and traffic shifting transparently, without app code changes', 'Rendering the user interface', 'Writing to the database'],
      correctIndex: 1,
      explanation: 'The sidecar absorbs cross-cutting networking concerns so services do not need to implement them individually.',
    ),
    QuizQuestion(
      question: 'What is network segmentation designed to prevent?',
      options: ['Slow queries', 'A database or internal service being directly reachable from the public internet', 'Long build times', 'Excessive logging'],
      correctIndex: 1,
      explanation: 'Segmentation (VPCs, subnets, security groups) keeps sensitive services reachable only from what actually needs them.',
    ),
    QuizQuestion(
      question: 'What does a WAF (Web Application Firewall) do?',
      options: ['Encrypts data at rest', 'Inspects HTTP traffic and blocks known attack patterns (SQLi, XSS, bad bots) before they reach the app', 'Generates TLS certificates', 'Balances load across servers by round robin'],
      correctIndex: 1,
      explanation: 'A WAF sits in front of the application, filtering malicious request patterns using rule-based and ML-based detection.',
    ),
    QuizQuestion(
      question: 'What is the role of DDoS protection services like Cloudflare or AWS Shield?',
      options: ['They replace the need for authentication', 'They absorb volumetric attacks at the edge before they reach origin servers', 'They encrypt database backups', 'They handle password resets'],
      correctIndex: 1,
      explanation: 'DDoS protection is positioned at the network edge to soak up floods of traffic before origin infrastructure is affected.',
    ),
  ];

  static const _threatModelingStride = [
    QuizQuestion(
      question: 'What does STRIDE stand for as a threat-modeling framework?',
      options: ['A single vulnerability type', 'Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege', 'A database replication strategy', 'A caching eviction policy'],
      correctIndex: 1,
      explanation: 'STRIDE is a mnemonic for six threat categories applied per system component.',
    ),
    QuizQuestion(
      question: 'Which STRIDE category is "pretending to be another user or service"?',
      options: ['Tampering', 'Spoofing', 'Repudiation', 'Denial of Service'],
      correctIndex: 1,
      explanation: 'Spoofing is impersonation — claiming a false identity to gain unauthorized access.',
    ),
    QuizQuestion(
      question: 'What is "Repudiation" in the STRIDE model, and how is it mitigated?',
      options: ['Overwhelming a system with traffic; mitigated by rate limiting', 'Denying an action occurred (e.g. "I never sent that transfer"); mitigated by an append-only audit log and digital signatures', 'Reading someone else\'s data; mitigated by encryption', 'Gaining higher permissions; mitigated by RBAC'],
      correctIndex: 1,
      explanation: 'Repudiation is about disputing that an action happened — non-repudiation proof (signed, immutable logs) counters it.',
    ),
    QuizQuestion(
      question: 'Which mitigation class primarily addresses Information Disclosure?',
      options: ['Rate limiting', 'Encryption, BOLA checks on every query, and masking sensitive data in responses', 'Auto-scaling', 'Digital signatures on transactions'],
      correctIndex: 1,
      explanation: 'Preventing unauthorized data exposure relies on encryption plus strict per-request authorization checks.',
    ),
    QuizQuestion(
      question: 'Why apply STRIDE per component rather than to the system as a whole?',
      options: ['STRIDE only works on a single monolithic component', 'Each component may have different threats and mitigations relevant to it, so per-component analysis surfaces more precise risks', 'It has no effect on the analysis either way', 'STRIDE cannot be applied to distributed systems'],
      correctIndex: 1,
      explanation: 'Different components (API gateway, database, queue) face different subsets of STRIDE threats, so a per-component pass is more thorough.',
    ),
  ];

  static const _auditLoggingNonrepudiation = [
    QuizQuestion(
      question: 'What makes an audit log trustworthy as evidence?',
      options: ['It is stored in a fast in-memory cache', 'It is append-only and immutable — even operators with elevated access cannot modify or delete entries', 'It is only kept for 24 hours', 'It is encrypted with a symmetric key shared by all services'],
      correctIndex: 1,
      explanation: 'Immutability is what prevents even a compromised insider from covering their tracks in the log.',
    ),
    QuizQuestion(
      question: 'What is "non-repudiation" in a security context?',
      options: ['The ability to undo any transaction', 'Cryptographic proof that a specific user performed a specific action, strong enough to hold up in a dispute', 'A type of rate limiting', 'A caching invalidation strategy'],
      correctIndex: 1,
      explanation: 'Non-repudiation means the user cannot plausibly deny having performed the signed action.',
    ),
    QuizQuestion(
      question: 'What does WORM (Write Once Read Many) storage guarantee?',
      options: ['Faster read performance only', 'Log entries physically cannot be overwritten or deleted, even by someone with elevated access', 'Automatic backups every hour', 'Data is compressed before storage'],
      correctIndex: 1,
      explanation: 'WORM storage (e.g. S3 Object Lock) enforces immutability at the storage layer itself.',
    ),
    QuizQuestion(
      question: 'Why include a trace_id on every logged sensitive action?',
      options: ['It speeds up encryption', 'It enables cross-system correlation when investigating an incident spanning multiple services', 'It is required for TLS handshakes', 'It replaces the need for a timestamp'],
      correctIndex: 1,
      explanation: 'A shared trace_id lets investigators follow one logical action across every service it touched.',
    ),
    QuizQuestion(
      question: 'What kinds of actions should always be logged in a fintech system?',
      options: ['Only failed login attempts', 'Every payment, admin action, and configuration change', 'Only successful page loads', 'Nothing — logging is optional for compliance'],
      correctIndex: 1,
      explanation: 'High-stakes actions (payments, admin actions, config changes) are exactly what audit logs exist to capture.',
    ),
  ];

  static const _fintechSecurityPatterns = [
    QuizQuestion(
      question: 'How does optimistic locking prevent a balance from being corrupted by concurrent writes?',
      options: ['By locking the row for the entire request', 'By updating only if the row\'s version/balance still matches what was read (WHERE version = N), retrying on 0 rows affected', 'By queuing all writes globally', 'By disabling concurrent access to the app entirely'],
      correctIndex: 1,
      explanation: 'A conditional UPDATE ensures a concurrent modification is detected (0 rows updated) rather than silently overwritten.',
    ),
    QuizQuestion(
      question: 'What does HMAC request signing protect against?',
      options: ['Slow network round-trips', 'Tampering and replay — the receiver verifies a signature over the payload and timestamp before processing', 'Running out of database storage', 'DNS resolution failures'],
      correctIndex: 1,
      explanation: 'HMAC-SHA256(secret, timestamp + body) lets the receiver confirm the request is genuine and unmodified.',
    ),
    QuizQuestion(
      question: 'What does webhook signature verification (X-Signature header) prevent?',
      options: ['Slow webhook delivery', 'An attacker spoofing a payment notification to a merchant', 'Webhooks from being retried', 'The need for HTTPS'],
      correctIndex: 1,
      explanation: 'Verifying the signature confirms a webhook payload genuinely originated from the expected sender.',
    ),
    QuizQuestion(
      question: 'What is a classic trigger for step-up authentication in fraud prevention?',
      options: ['A user viewing their own profile', 'A new device combined with an unusually large transaction', 'Logging in during business hours', 'Using a strong password'],
      correctIndex: 1,
      explanation: 'New device + large transaction is a common risk-scoring signal that prompts extra verification.',
    ),
    QuizQuestion(
      question: 'Which attack vectors commonly lead to Account Takeover (ATO)?',
      options: ['Slow page load times', 'Credential stuffing, phishing, and SIM swapping', 'Using HTTPS', 'Rate limiting'],
      correctIndex: 1,
      explanation: 'ATO is typically achieved via credential stuffing, phishing, or SIM swap, defended with MFA and anomaly detection.',
    ),
  ];

  static const _supplyChainSecurity = [
    QuizQuestion(
      question: 'What does a lockfile like go.sum or package-lock.json protect against?',
      options: ['Slow builds', 'A build silently pulling in a different, potentially compromised dependency version', 'SQL injection', 'DDoS attacks'],
      correctIndex: 1,
      explanation: 'Lockfiles pin exact versions/hashes so dependency resolution is reproducible and not silently swapped.',
    ),
    QuizQuestion(
      question: 'What is an SBOM (Software Bill of Materials) used for?',
      options: ['Encrypting source code', 'Providing a full inventory of every dependency, so exposure to a newly disclosed CVE can be assessed quickly', 'Load balancing incoming requests', 'Generating TLS certificates'],
      correctIndex: 1,
      explanation: 'An SBOM lets a team quickly determine whether a new vulnerability affects them by checking their dependency inventory.',
    ),
    QuizQuestion(
      question: 'Why scan for CVEs continuously in CI rather than just once at initial adoption?',
      options: ['It has no real benefit', 'New vulnerabilities are disclosed in already-adopted dependencies over time, so continuous scanning catches newly-discovered risk', 'CI scanning is required by law everywhere', 'It replaces the need for a lockfile'],
      correctIndex: 1,
      explanation: 'A dependency safe today can have a CVE disclosed tomorrow — continuous scanning catches that drift.',
    ),
    QuizQuestion(
      question: 'What does a "distroless" container base image provide?',
      options: ['Faster CPU performance', 'A minimal image with no shell or package manager, reducing what an attacker could use after a compromise', 'Automatic code compilation', 'Built-in load balancing'],
      correctIndex: 1,
      explanation: 'Distroless images strip out unnecessary tooling, shrinking the attack surface available post-compromise.',
    ),
    QuizQuestion(
      question: 'Which container hardening practices reduce the blast radius of a compromised container?',
      options: ['Running as root with a writable filesystem', 'Running as a non-root user, using a read-only filesystem, and dropping unnecessary Linux capabilities', 'Disabling all logging', 'Exposing every port by default'],
      correctIndex: 1,
      explanation: 'Non-root, read-only, and minimal capabilities all limit what an attacker can do even after breaking into a container.',
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

  static const _distributedTransactions2pcSaga = [
    QuizQuestion(
      question: 'What is the main downside of Two-Phase Commit (2PC)?',
      options: ['It cannot guarantee consistency', 'Participants hold locks while waiting for the vote, so one slow or dead node blocks everyone', 'It only works with a single participant', 'It requires no coordinator'],
      correctIndex: 1,
      explanation: '2PC keeps resources locked across the whole prepare/commit exchange, hurting availability and scalability.',
    ),
    QuizQuestion(
      question: 'How does a Saga handle a failure partway through a multi-step process?',
      options: ['It ignores the failure and continues', 'It runs compensating transactions to undo the steps that already completed', 'It restarts the entire cluster', 'It locks all participants until manually resolved'],
      correctIndex: 1,
      explanation: 'Sagas rely on explicit compensating actions per step rather than a global lock/rollback.',
    ),
    QuizQuestion(
      question: 'What is the difference between orchestrated and choreographed Sagas?',
      options: ['There is no difference', 'Orchestration uses a central coordinator telling each service what to do; choreography has each service react to events from the previous step', '2PC is a synonym for choreography', 'Choreography requires a central lock manager'],
      correctIndex: 1,
      explanation: 'Orchestration centralizes control flow; choreography distributes it via events, trading coupling for flexibility.',
    ),
    QuizQuestion(
      question: 'What tradeoff does a Saga accept in exchange for better availability than 2PC?',
      options: ['Higher storage cost only', 'The system passes through visibly inconsistent intermediate states while steps are in progress', 'It cannot span more than one service', 'It requires synchronous locking across all services'],
      correctIndex: 1,
      explanation: 'Without cross-service locks, other readers can observe a Saga mid-flight, before compensation (if needed) completes.',
    ),
    QuizQuestion(
      question: 'When is 2PC still a reasonable choice over a Saga?',
      options: ['Never — Sagas are always strictly better', 'When strict atomicity is non-negotiable and the set of participants is small and reliable', 'Only for read-only operations', 'When there is exactly one microservice in the system'],
      correctIndex: 1,
      explanation: '2PC still has a place where guaranteed atomicity matters more than availability and the participant set is limited.',
    ),
  ];

  static const _gossipProtocol = [
    QuizQuestion(
      question: 'How does a gossip protocol spread information through a cluster?',
      options: ['Every node broadcasts to every other node simultaneously', 'Each node periodically shares what it knows with a few random peers, who do the same next round', 'A single central server pushes updates to everyone', 'Nodes only exchange information once at startup'],
      correctIndex: 1,
      explanation: 'Gossip spreads state via repeated random peer exchanges rather than centralized or full broadcasts.',
    ),
    QuizQuestion(
      question: 'Why does gossip scale well as a cluster grows?',
      options: ['It requires a central coordinator that scales linearly', 'Each node only talks to a few random peers per round, so per-node bandwidth stays flat regardless of cluster size', 'Larger clusters gossip less frequently', 'It only works for clusters under 10 nodes'],
      correctIndex: 1,
      explanation: 'Because gossip fan-out per node is small and constant, the protocol does not require more per-node work as the cluster grows.',
    ),
    QuizQuestion(
      question: 'How does gossip-based failure detection typically work?',
      options: ['A central health-check server pings every node', 'Nodes periodically signal "still here"; missing several heartbeats marks a node suspect, and that news also spreads via gossip', 'Failures are detected only during a full cluster restart', 'Nodes never detect failures automatically'],
      correctIndex: 1,
      explanation: 'Heartbeat misses trigger suspicion, and that suspicion itself propagates through the same gossip mechanism.',
    ),
    QuizQuestion(
      question: 'What real systems use gossip protocols for cluster membership?',
      options: ['Traditional single-node relational databases', 'Cassandra and DynamoDB-style distributed databases', 'Static file servers', 'DNS root servers exclusively'],
      correctIndex: 1,
      explanation: 'Gossip is a foundational mechanism in Dynamo-style databases like Cassandra for tracking membership and health.',
    ),
    QuizQuestion(
      question: 'What is a key advantage of gossip over a centralized membership service?',
      options: ['It is always faster for small clusters of 2 nodes', 'No single point of failure and no central coordinator bottleneck', 'It eliminates the need for any network communication', 'It guarantees zero propagation delay'],
      correctIndex: 1,
      explanation: 'Decentralization is gossip\'s core benefit — the cluster keeps functioning even if individual nodes fail.',
    ),
  ];

  static const _vectorClocksHlc = [
    QuizQuestion(
      question: 'What question does a vector clock help answer?',
      options: ['How much disk space a node is using', 'Whether one event causally happened before another, or whether two events were concurrent', 'The exact wall-clock time an event occurred', 'How many replicas a database has'],
      correctIndex: 1,
      explanation: 'Vector clocks capture causal ordering between distributed events, which physical clocks alone cannot reliably do.',
    ),
    QuizQuestion(
      question: 'How does a Dynamo-style database use vector clocks?',
      options: ['To compress stored data', 'To detect concurrent, conflicting writes to the same key so they can be surfaced for resolution', 'To speed up TLS handshakes', 'To generate primary keys'],
      correctIndex: 1,
      explanation: 'When two writes are concurrent (neither vector clock dominates the other), the system flags a conflict rather than silently choosing one.',
    ),
    QuizQuestion(
      question: 'What does a Hybrid Logical Clock (HLC) combine?',
      options: ['Two separate physical clocks for redundancy', 'A logical counter with wall-clock time, so timestamps are both roughly human-meaningful and causally correct', 'A vector clock with a Bloom filter', 'A checksum and a hash function'],
      correctIndex: 1,
      explanation: 'HLCs blend logical ordering guarantees with real-time meaning, unlike a pure logical counter or a pure physical clock alone.',
    ),
    QuizQuestion(
      question: 'Why is naive last-write-wins by wall-clock timestamp risky in a distributed system?',
      options: ['Wall clocks are always perfectly synchronized', 'Clocks on different machines can drift, so a "later" timestamp is not guaranteed to reflect the true causal order, risking silent data loss', 'Wall-clock timestamps cannot be stored in a database', 'It is not risky at all'],
      correctIndex: 1,
      explanation: 'Clock drift between machines can make an earlier causal write appear to have a later timestamp, causing incorrect conflict resolution.',
    ),
    QuizQuestion(
      question: 'Do vector clocks or HLCs require perfectly synchronized physical clocks to work correctly?',
      options: ['Yes, both require perfect synchronization', 'No — both are designed to give correct causal ordering even when node clocks are not perfectly in sync', 'Only vector clocks require synchronization', 'Only HLCs require synchronization'],
      correctIndex: 1,
      explanation: 'Both mechanisms are specifically designed to tolerate the reality that distributed clocks are never perfectly synchronized.',
    ),
  ];

  static const _merkleTrees = [
    QuizQuestion(
      question: 'How is a Merkle tree constructed?',
      options: ['Randomly assigning hashes to nodes', 'Leaves hash data blocks, and each parent hashes the combination of its children\'s hashes, up to a single root hash', 'Only the root node is hashed', 'Each node stores a copy of the full dataset'],
      correctIndex: 1,
      explanation: 'The tree structure propagates hashes upward so the root summarizes the entire dataset in one value.',
    ),
    QuizQuestion(
      question: 'How do two replicas quickly check if their data is identical using Merkle trees?',
      options: ['By comparing every individual record', 'By comparing just their root hashes — a match means the data is identical', 'By re-downloading the entire dataset each time', 'By comparing only the timestamps of the last write'],
      correctIndex: 1,
      explanation: 'A single root-hash comparison can confirm equality without touching individual records.',
    ),
    QuizQuestion(
      question: 'When two replicas\' root hashes differ, what happens next?',
      options: ['The entire dataset is retransmitted from scratch', 'Only the branches whose hashes disagree are walked further, narrowing in on the actual divergence', 'The comparison is abandoned entirely', 'Both replicas are deleted and recreated'],
      correctIndex: 1,
      explanation: 'Merkle trees let you drill down only into the mismatched subtrees, avoiding a full scan.',
    ),
    QuizQuestion(
      question: 'Which distributed databases use Merkle trees for anti-entropy repair?',
      options: ['None — Merkle trees are theoretical only', 'Cassandra and Dynamo-style systems', 'Traditional single-node relational databases exclusively', 'In-memory caches only'],
      correctIndex: 1,
      explanation: 'Merkle-tree-based anti-entropy is a standard mechanism in Dynamo-style replicated databases like Cassandra.',
    ),
    QuizQuestion(
      question: 'What other well-known systems use the same Merkle tree idea?',
      options: ['Only spreadsheet software', 'Git (comparing commit trees) and blockchains (comparing block contents)', 'Only DNS resolution', 'Only video compression codecs'],
      correctIndex: 1,
      explanation: 'Merkle trees are a general-purpose technique for cheaply detecting divergence, used well beyond databases.',
    ),
  ];

  static const _bloomCuckooFilters = [
    QuizQuestion(
      question: 'Can a Bloom filter produce a false negative?',
      options: ['Yes, frequently', 'No — a Bloom filter never says an item is absent when it was actually added; it can only have false positives', 'Only after 50% capacity is reached', 'Only for string keys'],
      correctIndex: 1,
      explanation: 'Bloom filters guarantee no false negatives; the only error mode is a false positive ("maybe present" when it is not).',
    ),
    QuizQuestion(
      question: 'What is the main limitation of a standard Bloom filter compared to a Cuckoo filter?',
      options: ['It uses more memory', 'It cannot support deleting an item once added', 'It cannot be used with hash functions', 'It always has false negatives'],
      correctIndex: 1,
      explanation: 'A Cuckoo filter supports deletion; a classic Bloom filter does not, since bits are shared across items.',
    ),
    QuizQuestion(
      question: 'Why do LSM-tree databases like Cassandra put a Bloom filter per SSTable?',
      options: ['To compress the SSTable data', 'To avoid checking files on disk that definitely do not contain the key being looked up', 'To encrypt SSTable contents', 'To replicate SSTables across nodes'],
      correctIndex: 1,
      explanation: 'A "definitely not present" answer from the Bloom filter skips an expensive disk read entirely.',
    ),
    QuizQuestion(
      question: 'What happens when a Bloom filter says an item might be present ("maybe")?',
      options: ['The item is guaranteed to be present', 'It could be a false positive — the caller still needs to check the real source before trusting it', 'The filter automatically adds the item', 'The filter deletes a random other item'],
      correctIndex: 1,
      explanation: 'A "maybe" answer is probabilistic — callers still need to verify against the real data source since false positives are possible.',
    ),
    QuizQuestion(
      question: 'What extra capability does a Cuckoo filter add over a standard Bloom filter?',
      options: ['Faster network transmission', 'Support for removing (deleting) an item after it has been added', 'Unlimited capacity', 'Built-in encryption'],
      correctIndex: 1,
      explanation: 'Bloom filters cannot support deletion because bits are shared across multiple items; Cuckoo filters are designed to allow it.',
    ),
  ];

  static const _hyperloglog = [
    QuizQuestion(
      question: 'What does HyperLogLog estimate?',
      options: ['The exact sum of all values in a dataset', 'The approximate number of distinct items in a stream, using a small fixed amount of memory', 'The median of a dataset', 'The exact count of duplicate items'],
      correctIndex: 1,
      explanation: 'HyperLogLog is a cardinality estimator — it approximates "how many distinct items," not an exact count.',
    ),
    QuizQuestion(
      question: 'What is the typical accuracy tradeoff HyperLogLog makes?',
      options: ['Perfect accuracy at the cost of massive memory', 'A small error (commonly under 2%) in exchange for using only a few KB of memory regardless of scale', 'It only works for counts under 1000', 'It requires exact storage of every unique item'],
      correctIndex: 1,
      explanation: 'HyperLogLog\'s whole value proposition is bounded, small error for dramatically reduced memory use at any scale.',
    ),
    QuizQuestion(
      question: 'How does Redis expose HyperLogLog functionality?',
      options: ['It does not support HyperLogLog', 'Via PFADD to add items and PFCOUNT to estimate cardinality', 'Only through a third-party plugin', 'Via SQL queries'],
      correctIndex: 1,
      explanation: 'Redis ships HyperLogLog natively with the PFADD/PFCOUNT command family.',
    ),
    QuizQuestion(
      question: 'What is a good use case for HyperLogLog?',
      options: ['Storing exact user account balances', 'Estimating unique visitors or unique search queries at scale', 'Guaranteeing no duplicate payments are processed', 'Encrypting sensitive data'],
      correctIndex: 1,
      explanation: 'HyperLogLog fits "roughly how many uniques" questions, not situations requiring an exact count or strong guarantees.',
    ),
    QuizQuestion(
      question: 'Can multiple HyperLogLog sketches be combined?',
      options: ['No, each sketch is isolated forever', 'Yes — they can be merged (union) without losing accuracy, useful for combining per-shard or per-hour counts', 'Only if they were created on the same machine', 'Only by recomputing from raw data'],
      correctIndex: 1,
      explanation: 'HyperLogLog sketches support mergeable unions, letting partial estimates be combined into a total estimate.',
    ),
  ];

  static const _consistentHashing = [
    QuizQuestion(
      question: 'What goes wrong with naive hash(key) % N sharding when N changes?',
      options: ['Nothing, it works perfectly', 'Almost every key remaps to a different node, causing a massive unnecessary data reshuffle', 'Only one key needs to move', 'It becomes faster automatically'],
      correctIndex: 1,
      explanation: 'Modulo-based sharding is extremely sensitive to changes in N, since the modulus itself changes for nearly every key.',
    ),
    QuizQuestion(
      question: 'How does consistent hashing decide which node owns a key?',
      options: ['Random assignment each time', 'The key is placed on a hash ring, and the first node found walking clockwise from that position owns it', 'Alphabetical order of the key', 'The node with the most free memory'],
      correctIndex: 1,
      explanation: 'Consistent hashing maps both keys and nodes onto a ring, using ring position (not key % N) to determine ownership.',
    ),
    QuizQuestion(
      question: 'What is the impact of adding or removing a node in consistent hashing?',
      options: ['The entire keyspace must be reshuffled', 'Only the keys between the changed node and its neighbor on the ring are remapped — the rest stay put', 'No keys are ever remapped', 'All nodes must be restarted'],
      correctIndex: 1,
      explanation: 'Consistent hashing localizes the impact of membership changes to a small neighborhood on the ring.',
    ),
    QuizQuestion(
      question: 'What problem do virtual nodes solve in consistent hashing?',
      options: ['They encrypt the ring positions', 'Each physical node claims multiple ring positions, spreading load more evenly and avoiding hot spots', 'They eliminate the need for hashing entirely', 'They reduce the total number of physical nodes needed'],
      correctIndex: 1,
      explanation: 'Without virtual nodes, an unlucky ring distribution can leave one physical node owning a disproportionate share of keys.',
    ),
    QuizQuestion(
      question: 'Which systems commonly rely on consistent hashing?',
      options: ['Single-node relational databases only', 'Distributed caches and databases like DynamoDB, Cassandra, and memcached client-side sharding', 'Static HTML file servers', 'DNS root servers exclusively'],
      correctIndex: 1,
      explanation: 'Consistent hashing is a foundational technique wherever a distributed store needs to scale node count without a full data migration.',
    ),
  ];

  static const _btreeVsLsm = [
    QuizQuestion(
      question: 'How does a B-tree handle writes?',
      options: ['By appending sequentially to a log', 'By editing the relevant page in place, which involves random disk I/O', 'By never persisting writes to disk', 'By storing writes only in memory permanently'],
      correctIndex: 1,
      explanation: 'B-trees update the actual page containing the record, which is a random-access operation.',
    ),
    QuizQuestion(
      question: 'Why are LSM trees considered write-optimized?',
      options: ['They skip writing to disk entirely', 'Writes go to an in-memory memtable and are appended sequentially, which is far cheaper than random-access page edits', 'They compress every write before storing it', 'They only support single-threaded writes'],
      correctIndex: 1,
      explanation: 'Sequential appends are much cheaper than the random I/O a B-tree needs for in-place updates.',
    ),
    QuizQuestion(
      question: 'What is the role of compaction in an LSM tree?',
      options: ['Encrypting SSTables', 'Merging and tidying SSTables in the background, removing overwritten/deleted entries so reads don\'t check ever-more files', 'Replicating data to other nodes', 'Generating backups'],
      correctIndex: 1,
      explanation: 'Compaction keeps the number of files reads need to check bounded, maintaining read performance over time.',
    ),
    QuizQuestion(
      question: 'Which storage engine style would you pick for a write-heavy workload like time-series ingestion?',
      options: ['B-tree', 'LSM tree', 'Neither supports writes', 'It makes no difference'],
      correctIndex: 1,
      explanation: 'LSM trees are optimized for high write throughput, which fits heavy-ingestion workloads well.',
    ),
    QuizQuestion(
      question: 'What database examples use a B-tree vs an LSM tree as their primary storage engine?',
      options: ['Both Postgres and Cassandra use B-trees', 'Postgres/MySQL InnoDB typically use B-trees; Cassandra/RocksDB/LevelDB use LSM trees', 'Both use LSM trees exclusively', 'Neither uses either structure'],
      correctIndex: 1,
      explanation: 'This maps to the read-optimized vs write-optimized tradeoff each database family is generally tuned for.',
    ),
  ];

  static const _oltpVsOlap = [
    QuizQuestion(
      question: 'What characterizes an OLTP workload?',
      options: ['Few queries scanning millions of rows for aggregates', 'Many small, low-latency reads/writes on individual rows', 'No writes at all, only analytics', 'Batch processing run once a year'],
      correctIndex: 1,
      explanation: 'OLTP is the live application workload: frequent, small, fast operations on individual records.',
    ),
    QuizQuestion(
      question: 'What characterizes an OLAP workload?',
      options: ['Millisecond single-row lookups only', 'Fewer, larger queries that aggregate across millions of rows', 'It never touches historical data', 'It is identical to OLTP'],
      correctIndex: 1,
      explanation: 'OLAP is analytics: large scans and aggregations, prioritizing throughput over per-query latency.',
    ),
    QuizQuestion(
      question: 'Why is running heavy analytical queries directly against a production OLTP database risky?',
      options: ['It is completely safe with no downsides', 'It competes for the same resources as live application traffic and can degrade performance for real users', 'OLTP databases cannot execute SELECT statements', 'It automatically corrupts the data'],
      correctIndex: 1,
      explanation: 'Large OLAP-style scans can starve the live application of I/O and CPU on a shared OLTP database.',
    ),
    QuizQuestion(
      question: 'What is the typical pattern for separating OLTP and OLAP workloads?',
      options: ['Run everything on one database and hope for the best', 'OLTP stays the app\'s source of truth; data is periodically piped into a dedicated OLAP/analytics store', 'Delete the OLTP data once analytics is needed', 'OLAP queries are banned entirely'],
      correctIndex: 1,
      explanation: 'Separation via ETL/streaming lets each system be optimized for its own access pattern without conflict.',
    ),
    QuizQuestion(
      question: 'Which of these is a typical OLAP-oriented data store?',
      options: ['A typical OLTP-tuned Postgres instance', 'Snowflake, BigQuery, Redshift, or ClickHouse', 'A Redis in-memory cache', 'A message queue like Kafka'],
      correctIndex: 1,
      explanation: 'These are columnar, analytics-oriented warehouses purpose-built for large aggregate queries.',
    ),
  ];

  static const _dataWarehouseLakeLakehouse = [
    QuizQuestion(
      question: 'What is a key characteristic of a data warehouse?',
      options: ['It stores only raw, unstructured data', 'It stores structured, schema-enforced data optimized for fast analytical queries', 'It has no schema at all', 'It is only used for real-time application state'],
      correctIndex: 1,
      explanation: 'Warehouses enforce schema up front, which is what makes their analytical queries fast and predictable.',
    ),
    QuizQuestion(
      question: 'What is the tradeoff a data lake makes compared to a warehouse?',
      options: ['It is more expensive but faster', 'It stores data of any shape cheaply at scale, deferring schema to read time, but risks becoming a disorganized "data swamp"', 'It cannot store any unstructured data', 'It has no tradeoffs at all'],
      correctIndex: 1,
      explanation: 'Lakes prioritize flexibility and cost over the up-front structure a warehouse enforces.',
    ),
    QuizQuestion(
      question: 'What does a lakehouse (Delta Lake, Apache Iceberg) try to combine?',
      options: ['Only the cost benefits of a lake, nothing else', 'Cheap lake-style storage with warehouse-style schema enforcement, ACID transactions, and query performance', 'Only the schema strictness of a warehouse', 'A replacement for OLTP databases'],
      correctIndex: 1,
      explanation: 'Lakehouses layer structure and transactional guarantees on top of cheap object storage.',
    ),
    QuizQuestion(
      question: 'Why do modern warehouses/lakehouses favor columnar storage formats like Parquet?',
      options: ['Columnar formats are required for row-by-row transactional updates', 'Analytical queries typically read a few columns across many rows, which columnar layout serves efficiently', 'Columnar formats cannot be compressed', 'They are slower but more secure'],
      correctIndex: 1,
      explanation: 'Storing data column-by-column lets an aggregate query read only the relevant columns instead of full rows.',
    ),
    QuizQuestion(
      question: 'Which storage style best fits "cheap, flexible storage for many different raw data shapes"?',
      options: ['Data warehouse', 'Data lake', 'A single-node relational database', 'An in-memory cache'],
      correctIndex: 1,
      explanation: 'Lakes are designed precisely for cheap, schema-flexible storage at scale.',
    ),
  ];

  static const _changeDataCapture = [
    QuizQuestion(
      question: 'What does Change Data Capture (CDC) read from to detect changes?',
      options: ['The application\'s HTTP access logs', 'The database\'s own internal transaction log (WAL or binlog)', 'A manually maintained changelog file', 'The database\'s query cache'],
      correctIndex: 1,
      explanation: 'CDC taps directly into the database\'s transaction log rather than polling tables or logging changes separately.',
    ),
    QuizQuestion(
      question: 'What is Debezium commonly used for?',
      options: ['Compiling application code', 'Tailing a database\'s transaction log and publishing row-level changes as events, typically to Kafka', 'Load balancing HTTP traffic', 'Generating TLS certificates'],
      correctIndex: 1,
      explanation: 'Debezium is the standard open-source CDC connector for streaming database changes into Kafka.',
    ),
    QuizQuestion(
      question: 'What problem does CDC avoid compared to application-level dual writes?',
      options: ['It avoids the need for a database entirely', 'It avoids dual-write bugs, where a DB write and a separate write to another system (like a search index) could get out of sync if one fails', 'It avoids the need for any network calls', 'It eliminates the need for backups'],
      correctIndex: 1,
      explanation: 'Since CDC reads from the single source of truth (the transaction log), there is no separate write path that can drift out of sync.',
    ),
    QuizQuestion(
      question: 'Which downstream systems commonly consume a CDC change stream?',
      options: ['None — CDC output is not consumed by anything', 'Search indexes, caches (for invalidation), analytics warehouses, and other microservices', 'Only the original database itself', 'Only the client\'s web browser'],
      correctIndex: 1,
      explanation: 'CDC streams are commonly fanned out to keep multiple downstream systems in sync with the source database.',
    ),
    QuizQuestion(
      question: 'Does CDC require changes to the application code that writes to the database?',
      options: ['Yes, every write path must be rewritten', 'No — CDC reads the database\'s own log, so it works without app-level changes', 'Only if the database is NoSQL', 'Only for delete operations'],
      correctIndex: 1,
      explanation: 'Because CDC observes the transaction log itself, the application does not need to change how it writes data.',
    ),
  ];

  static const _normalizeVsDenormalize = [
    QuizQuestion(
      question: 'What does normalizing a schema mean?',
      options: ['Duplicating data across multiple tables for speed', 'Storing each fact exactly once and linking related data via foreign keys', 'Removing all indexes', 'Storing everything as unstructured JSON'],
      correctIndex: 1,
      explanation: 'Normalization eliminates duplication by storing each fact in one place and referencing it elsewhere.',
    ),
    QuizQuestion(
      question: 'What is the main tradeoff of a normalized schema?',
      options: ['It uses far more storage than denormalized schemas', 'Reads often require joins across multiple tables', 'It cannot enforce data integrity', 'It is only usable with NoSQL databases'],
      correctIndex: 1,
      explanation: 'Avoiding duplication means related data often lives in separate tables, requiring joins to read together.',
    ),
    QuizQuestion(
      question: 'What is the benefit of denormalizing, e.g. storing an author\'s name directly on a post?',
      options: ['It reduces total storage used', 'It avoids a join at read time, making reads faster and simpler, at the cost of needing to update duplicated data in multiple places', 'It removes the need for any database', 'It guarantees data is always consistent automatically'],
      correctIndex: 1,
      explanation: 'Denormalization trades some storage and write complexity for significantly faster, simpler reads.',
    ),
    QuizQuestion(
      question: 'What does "query-first design" mean in the context of NoSQL schema modeling?',
      options: ['Designing the schema around the exact read queries the application needs, since there are no joins to rely on', 'Writing all SQL queries before writing any code', 'Ignoring performance until production', 'Only supporting a single query per table'],
      correctIndex: 0,
      explanation: 'Without cheap joins, NoSQL schemas are typically shaped directly around the specific access patterns the app will use.',
    ),
    QuizQuestion(
      question: 'What is a common middle-ground pattern between normalization and denormalization?',
      options: ['Pick one and never mix them', 'Normalize the OLTP source of truth, then denormalize into read-optimized views/caches for hot query paths', 'Denormalize everything including the source of truth', 'Normalize only string columns'],
      correctIndex: 1,
      explanation: 'Keeping a clean normalized source of truth while denormalizing derived read paths gets benefits of both approaches.',
    ),
  ];

  static const _microservicesVsMonolith = [
    QuizQuestion(
      question: 'What is a key advantage of a monolith early in a project?',
      options: ['Unlimited independent scaling of every feature', 'Simplicity — one codebase, one deployment, easy to develop and reason about', 'It requires no database at all', 'It automatically handles eventual consistency'],
      correctIndex: 1,
      explanation: 'A monolith\'s single codebase and deployment keeps early development simple, before scale or team size demands more.',
    ),
    QuizQuestion(
      question: 'What new class of problems do microservices introduce compared to a monolith?',
      options: ['None — microservices have no downsides', 'Network calls replacing function calls, eventual consistency across services, and greater operational complexity', 'The need for a database', 'Slower local development for a single feature'],
      correctIndex: 1,
      explanation: 'Splitting a monolith into services turns in-process calls into network calls with all their new failure modes.',
    ),
    QuizQuestion(
      question: 'What does Conway\'s Law state?',
      options: ['Systems always outperform monoliths', 'System structure tends to mirror the communication/team structure that built it', 'Microservices are always faster than monoliths', 'Databases must be normalized'],
      correctIndex: 1,
      explanation: 'Conway\'s Law observes that software architecture reflects organizational structure — a key reason to align service boundaries with team boundaries.',
    ),
    QuizQuestion(
      question: 'What is a common, pragmatic path many successful systems take?',
      options: ['Always start with microservices from day one', 'Start as a monolith, and extract services only where independent scaling or ownership genuinely justifies the added complexity', 'Never migrate away from a monolith', 'Rewrite in microservices every year'],
      correctIndex: 1,
      explanation: 'Starting simple and extracting services incrementally, as real needs emerge, avoids paying distributed-systems costs prematurely.',
    ),
    QuizQuestion(
      question: 'What is a key benefit microservices offer over a monolith when done well?',
      options: ['Zero network latency', 'Independent deployability and scaling per service, plus clearer team ownership boundaries', 'Automatic elimination of all bugs', 'No need for monitoring'],
      correctIndex: 1,
      explanation: 'The main payoff of microservices is being able to scale, deploy, and own services independently.',
    ),
  ];

  static const _cqrsEventSourcing = [
    QuizQuestion(
      question: 'What does CQRS stand for and mean?',
      options: ['Command Query Responsibility Segregation — separate models for writes and reads', 'A database replication protocol', 'A type of consistent hashing', 'A caching eviction policy'],
      correctIndex: 0,
      explanation: 'CQRS splits the write (command) model from the read (query) model, letting each be optimized independently.',
    ),
    QuizQuestion(
      question: 'Why might the read side in CQRS be denormalized and eventually consistent?',
      options: ['Because denormalization is required for all databases', 'Because it is purpose-built for fast reads, independent of the write model\'s validation/consistency needs', 'Because CQRS forbids normalized data structures', 'Because reads are always slower than writes'],
      correctIndex: 1,
      explanation: 'The read model can be shaped purely around query needs, since it is decoupled from the write model.',
    ),
    QuizQuestion(
      question: 'What does Event Sourcing store, instead of just the current state?',
      options: ['Only a snapshot of the current state', 'The full sequence of events that led to the current state', 'Nothing — Event Sourcing has no persistence', 'Only the most recent event'],
      correctIndex: 1,
      explanation: 'Event sourcing keeps the complete history of changes, deriving current state by replaying them.',
    ),
    QuizQuestion(
      question: 'What is a major benefit of Event Sourcing?',
      options: ['It eliminates the need for any database', 'A complete audit trail comes for free, and new read models can be built later by replaying history', 'It guarantees zero latency reads', 'It removes the need for testing'],
      correctIndex: 1,
      explanation: 'Since every change is recorded as an event, you get a full history and the flexibility to derive new views from it later.',
    ),
    QuizQuestion(
      question: 'Are CQRS and Event Sourcing required to be used together?',
      options: ['Yes, they are the same pattern', 'No — they are independent choices, often paired but each usable without the other', 'CQRS requires Event Sourcing to function at all', 'Event Sourcing requires CQRS to function at all'],
      correctIndex: 1,
      explanation: 'They complement each other well but are architecturally separate decisions.',
    ),
  ];

  static const _circuitBreakerBulkhead = [
    QuizQuestion(
      question: 'What happens when a circuit breaker "trips" to the open state?',
      options: ['It sends even more traffic to test recovery', 'It stops sending traffic to the failing dependency and fails fast locally instead', 'It permanently deletes the dependency', 'It doubles the timeout for every request'],
      correctIndex: 1,
      explanation: 'An open circuit breaker rejects calls immediately rather than letting them pile up against a failing dependency.',
    ),
    QuizQuestion(
      question: 'What is the purpose of the half-open state in a circuit breaker?',
      options: ['To permanently block all future traffic', 'To let a small trial request through and check whether the dependency has recovered before fully closing again', 'To double the request rate', 'To delete cached responses'],
      correctIndex: 1,
      explanation: 'Half-open is a cautious probe: a limited number of requests test recovery before resuming full traffic.',
    ),
    QuizQuestion(
      question: 'Why is failing fast better than letting requests queue up against a down dependency?',
      options: ['It is not better, queuing is always preferred', 'Piled-up slow/timing-out requests can exhaust threads and connections, risking a cascading failure elsewhere', 'Failing fast uses more memory', 'It has no real effect on system health'],
      correctIndex: 1,
      explanation: 'Resource exhaustion from stuck requests is exactly the cascading-failure risk fail-fast circuit breaking avoids.',
    ),
    QuizQuestion(
      question: 'What does the bulkhead pattern do?',
      options: ['It merges all resource pools into one shared pool', 'It partitions resources (connection/thread pools) per dependency, so one failing dependency cannot starve others', 'It encrypts traffic between services', 'It replaces the need for a circuit breaker entirely'],
      correctIndex: 1,
      explanation: 'Like watertight compartments in a ship, bulkheads contain a failure to the resources allocated for that specific dependency.',
    ),
    QuizQuestion(
      question: 'What do circuit breakers and bulkheads have in common as patterns?',
      options: ['Both encrypt data at rest', 'Both aim to contain the blast radius of one dependency\'s failure rather than let it cascade through the system', 'Both are used only for database indexing', 'Both are authentication mechanisms'],
      correctIndex: 1,
      explanation: 'They are complementary resilience patterns focused on isolating and containing failure.',
    ),
  ];

  static const _serviceMeshSidecar = [
    QuizQuestion(
      question: 'What does a sidecar proxy handle on behalf of a service?',
      options: ['Compiling the service\'s source code', 'mTLS, retries, timeouts, load balancing, and telemetry, transparently', 'Storing the service\'s primary database', 'Rendering the user interface'],
      correctIndex: 1,
      explanation: 'The sidecar absorbs cross-cutting networking concerns so the service code does not need to implement them.',
    ),
    QuizQuestion(
      question: 'What is the role of a service mesh\'s control plane (e.g. Istio)?',
      options: ['It stores application data', 'It centrally configures every sidecar proxy, so policies are set once instead of reimplemented per service', 'It replaces the need for a load balancer entirely', 'It compiles application binaries'],
      correctIndex: 1,
      explanation: 'The control plane pushes configuration to all the sidecars, giving consistent, centrally managed behavior.',
    ),
    QuizQuestion(
      question: 'How can a service mesh change traffic routing (e.g. for a canary release) without redeploying app code?',
      options: ['It cannot — code changes are always required', 'By updating mesh-level traffic policy, since routing is handled by the sidecars, not the application', 'By manually editing each service\'s source code', 'By restarting the entire cluster'],
      correctIndex: 1,
      explanation: 'Because routing logic lives in the mesh/sidecars, traffic-shifting policy changes do not require touching application code.',
    ),
    QuizQuestion(
      question: 'What is a real cost of adopting a service mesh?',
      options: ['It has no costs at all', 'Added operational complexity and per-hop latency overhead from the extra proxy layer', 'It removes the ability to use mTLS', 'It eliminates the need for any monitoring'],
      correctIndex: 1,
      explanation: 'Every request now passes through sidecar proxies, adding both operational surface area and a small latency cost.',
    ),
    QuizQuestion(
      question: 'When does adopting a service mesh tend to pay off?',
      options: ['For a single-service application', 'Once there are enough services that reimplementing networking logic per-service becomes the bigger cost', 'Only for static websites', 'Never — it is purely overhead'],
      correctIndex: 1,
      explanation: 'The value of centralizing cross-cutting networking logic grows with the number of services that would otherwise duplicate it.',
    ),
  ];

  static const _apiGatewayBff = [
    QuizQuestion(
      question: 'What does an API Gateway centralize before requests reach individual services?',
      options: ['Only database backups', 'Authentication, coarse-grained rate limiting, routing, and basic authorization', 'Nothing — it just forwards packets unmodified', 'Compilation of service code'],
      correctIndex: 1,
      explanation: 'The gateway handles cross-cutting concerns once, so individual services don\'t need to reimplement them.',
    ),
    QuizQuestion(
      question: 'From a client\'s perspective, what does an API Gateway hide?',
      options: ['The client\'s own IP address', 'Which specific backend service actually handled the request', 'The existence of HTTPS', 'The request method (GET/POST)'],
      correctIndex: 1,
      explanation: 'Clients talk only to the gateway; the underlying service topology stays invisible to them.',
    ),
    QuizQuestion(
      question: 'What problem does a Backend-for-Frontend (BFF) solve?',
      options: ['It replaces the need for any backend service', 'A generic one-size-fits-all API forcing clients to over-fetch or make many round trips — BFF tailors a layer per client type', 'It eliminates the need for authentication', 'It only applies to mobile apps, never web'],
      correctIndex: 1,
      explanation: 'BFF shapes the API around each specific client\'s actual data needs, instead of one generic API for everyone.',
    ),
    QuizQuestion(
      question: 'What is a risk of introducing an API Gateway?',
      options: ['It has no risks at all', 'It becomes a new operational component and potential bottleneck/single point of failure if not made highly available', 'It automatically encrypts all backend data', 'It removes the need for load balancing entirely'],
      correctIndex: 1,
      explanation: 'Since all traffic flows through it, the gateway itself needs to be scaled and made resilient.',
    ),
    QuizQuestion(
      question: 'How many gateway/aggregation layers does the BFF pattern typically introduce?',
      options: ['Exactly one shared by every client', 'One per client type (web, iOS, Android), each tailored to that client', 'Zero — BFF removes the gateway concept entirely', 'One per individual user'],
      correctIndex: 1,
      explanation: 'BFF\'s defining trait is a dedicated layer per client type rather than one generic layer for all clients.',
    ),
  ];

  static const _nTierThickThinClient = [
    QuizQuestion(
      question: 'What distinguishes a 3-tier architecture from a 2-tier one?',
      options: ['3-tier has no database', ' 3-tier adds a dedicated application/business-logic layer between the client and the database', '2-tier and 3-tier are identical', '3-tier removes the client entirely'],
      correctIndex: 1,
      explanation: '2-tier is just client-server; 3-tier separates business logic into its own layer.',
    ),
    QuizQuestion(
      question: 'What is a thick client?',
      options: ['A client that does almost nothing locally', 'A client (native app, feature-rich mobile app) that performs significant logic and stores data locally', 'A synonym for a thin client', 'A client that cannot run offline under any circumstances'],
      correctIndex: 1,
      explanation: 'Thick clients handle meaningful work and state locally, unlike thin clients that depend on the server for almost everything.',
    ),
    QuizQuestion(
      question: 'What is a key advantage of a thin client architecture?',
      options: ['Rich offline support', 'Updates are trivial — change the server, and every client benefits immediately without shipping a new release', 'It requires no server at all', 'It performs all computation locally'],
      correctIndex: 1,
      explanation: 'Since logic lives server-side, thin clients get updates automatically without needing new client builds.',
    ),
    QuizQuestion(
      question: 'What is a tradeoff of a thick client compared to a thin one?',
      options: ['Thick clients cannot store any data', 'Thick clients are harder to update everywhere at once, since logic/data live on each individual device', 'Thick clients always require more server resources', 'There is no meaningful tradeoff'],
      correctIndex: 1,
      explanation: 'Distributing logic to clients means a fix or feature has to be shipped and adopted across many individual devices.',
    ),
    QuizQuestion(
      question: 'What generally happens to separation of concerns as you add more tiers?',
      options: ['It gets worse with more tiers', 'It generally improves, at the cost of more network hops and operational pieces to manage', 'Tiers have no relationship to separation of concerns', 'Adding tiers always reduces latency'],
      correctIndex: 1,
      explanation: 'More tiers typically isolate responsibilities more cleanly, but add architectural and operational overhead.',
    ),
  ];

  static const _stranglerFigPattern = [
    QuizQuestion(
      question: 'What is the core idea of the strangler fig pattern?',
      options: ['Rewrite the entire system in one release', 'Incrementally redirect traffic from the old system to the new one, one slice at a time, with both running side by side', 'Delete the legacy system before building the replacement', 'Only migrate systems with no active users'],
      correctIndex: 1,
      explanation: 'The pattern is named for a vine that gradually grows around and replaces a host tree without ever felling it outright.',
    ),
    QuizQuestion(
      question: 'What component decides whether a request goes to the old or new system during a strangler fig migration?',
      options: ['The end user manually chooses each time', 'A router/proxy in front of both systems', 'There is no such component — both handle every request identically', 'The database decides based on data age'],
      correctIndex: 1,
      explanation: 'A routing layer directs traffic to whichever system currently owns a given slice of functionality.',
    ),
    QuizQuestion(
      question: 'What is the main risk this pattern avoids compared to a "big bang" rewrite?',
      options: ['The risk of ever writing new code', 'A risky all-at-once cutover with no way to validate the new system against real traffic before full switchover', 'The need for testing', 'The cost of running two systems at all'],
      correctIndex: 1,
      explanation: 'Incremental migration lets each slice be validated against production traffic before expanding further.',
    ),
    QuizQuestion(
      question: 'When is the legacy system finally decommissioned in this pattern?',
      options: ['On day one of the migration', 'Only once every code path has been migrated and nothing routes to it anymore', 'It is never decommissioned', 'As soon as the new system is deployed, regardless of traffic'],
      correctIndex: 1,
      explanation: 'The legacy system stays live and serving traffic until it has been fully "strangled" — no remaining routes point to it.',
    ),
    QuizQuestion(
      question: 'Why migrate "one slice (endpoint/feature) at a time" instead of everything at once?',
      options: ['It is slower with no other benefit', 'Each slice can be independently validated, limiting the blast radius of any migration issue', 'Slices cannot be tested individually', 'It requires deleting old code immediately'],
      correctIndex: 1,
      explanation: 'Migrating incrementally contains risk to a small, verifiable piece of functionality at a time.',
    ),
  ];

  static const _httpEvolution = [
    QuizQuestion(
      question: 'How do browsers work around HTTP/1.1 only allowing one request in flight per connection?',
      options: ['They wait for each request to finish before sending the next, always', 'They open several parallel connections to the same server', 'They switch to UDP automatically', 'They cache every response forever'],
      correctIndex: 1,
      explanation: 'Multiple parallel connections let HTTP/1.1 clients approximate concurrency, at the cost of connection overhead.',
    ),
    QuizQuestion(
      question: 'What does HTTP/2 multiplexing achieve?',
      options: ['It requires a new connection per request, like HTTP/1.1', 'Many requests share a single TCP connection using binary framing, removing the need for multiple parallel connections', 'It disables all compression', 'It only works for GET requests'],
      correctIndex: 1,
      explanation: 'HTTP/2 interleaves multiple request/response streams over one connection, cutting the overhead of many separate connections.',
    ),
    QuizQuestion(
      question: 'What limitation does HTTP/2 still have due to running over TCP?',
      options: ['It cannot compress headers', 'A single lost packet blocks all multiplexed streams on that connection (head-of-line blocking)', 'It cannot support more than one request', 'It requires a new TCP connection per request'],
      correctIndex: 1,
      explanation: 'TCP guarantees in-order delivery across the whole connection, so one lost packet stalls every stream sharing it.',
    ),
    QuizQuestion(
      question: 'What transport does HTTP/3 use instead of TCP?',
      options: ['UDP directly, with no additional protocol', 'QUIC, which runs over UDP', 'A new version of TCP', 'FTP'],
      correctIndex: 1,
      explanation: 'HTTP/3 is built on QUIC, a UDP-based transport that avoids TCP\'s connection-wide head-of-line blocking.',
    ),
    QuizQuestion(
      question: 'What extra resilience does HTTP/3 (via QUIC) provide that HTTP/2 does not?',
      options: ['It compresses images automatically', 'Connections survive a client\'s network change (e.g. wifi to cellular) without a fresh handshake', 'It eliminates the need for encryption', 'It removes the need for a server entirely'],
      correctIndex: 1,
      explanation: 'QUIC connection IDs are decoupled from the underlying IP/port, letting connections migrate across networks seamlessly.',
    ),
  ];

  static const _grpcProtobuf = [
    QuizQuestion(
      question: 'What is Protocol Buffers (protobuf)?',
      options: ['A human-readable text format like JSON', 'A compact binary serialization format defined by a strict, versioned schema', 'A type of database index', 'A load balancing algorithm'],
      correctIndex: 1,
      explanation: 'Protobuf trades human-readability for a smaller, faster-to-parse binary wire format.',
    ),
    QuizQuestion(
      question: 'What transport protocol does gRPC run over?',
      options: ['HTTP/1.1 only', 'HTTP/2', 'Raw TCP with no HTTP layer', 'UDP directly'],
      correctIndex: 1,
      explanation: 'gRPC is built on HTTP/2, inheriting its multiplexing and framing.',
    ),
    QuizQuestion(
      question: 'What capability does gRPC get natively from running over HTTP/2 that plain REST lacks a standard answer for?',
      options: ['Header compression only', 'Client, server, and bidirectional streaming', 'The ability to use JSON', 'Basic authentication'],
      correctIndex: 1,
      explanation: 'HTTP/2\'s multiplexed streams give gRPC built-in support for long-lived streaming in either or both directions.',
    ),
    QuizQuestion(
      question: 'How are gRPC client and server code kept in sync?',
      options: ['Manually, with no tooling support', 'Both are code-generated from the same .proto schema file, catching mismatches at compile time', 'They are never guaranteed to match', 'By writing separate JSON schemas for each side'],
      correctIndex: 1,
      explanation: 'Schema-first codegen means client and server stubs are derived from one shared source of truth.',
    ),
    QuizQuestion(
      question: 'Where does gRPC fit best compared to REST/JSON?',
      options: ['Public browser-facing APIs where human readability matters most', 'Internal service-to-service traffic where performance and strict schemas matter', 'It is a strict replacement for REST in all cases', 'Only for static file serving'],
      correctIndex: 1,
      explanation: 'gRPC\'s performance and schema strictness shine for internal traffic; REST/JSON remains more accessible for public APIs.',
    ),
  ];

  static const _webrtcAndRealtime = [
    QuizQuestion(
      question: 'How does WebRTC connect two browsers on a video call?',
      options: ['All media is routed through a central server permanently', 'Directly, peer-to-peer — a signaling server only helps them find each other and negotiate, then steps out of the data path', 'Through email attachments', 'Via DNS lookups only'],
      correctIndex: 1,
      explanation: 'WebRTC\'s signaling server assists connection setup but is not in the media path once the peer connection is established.',
    ),
    QuizQuestion(
      question: 'Why does WebRTC tolerate some packet loss instead of retransmitting?',
      options: ['Retransmission is impossible over UDP', 'Retransmitting would add latency real-time audio/video cannot afford', 'Packet loss never actually occurs in WebRTC', 'It always uses TCP for reliability'],
      correctIndex: 1,
      explanation: 'For live media, a slightly degraded frame now is better than a perfect frame delayed by a retransmit round trip.',
    ),
    QuizQuestion(
      question: 'Is WebRTC traffic encrypted by default?',
      options: ['No, encryption must be added separately', 'Yes — encryption (DTLS-SRTP) is built in, not an opt-in add-on', 'Only for text chat, never for media', 'Only when using a paid service'],
      correctIndex: 1,
      explanation: 'WebRTC mandates encryption as part of the standard, unlike plain WebSockets where security is opt-in.',
    ),
    QuizQuestion(
      question: 'Which protocol fits a one-way live ticker where the server continuously pushes updates to the client?',
      options: ['WebRTC', 'Server-Sent Events (SSE)', 'gRPC exclusively', 'FTP'],
      correctIndex: 1,
      explanation: 'SSE is designed exactly for one-directional server-to-client push, simpler than a full-duplex WebSocket for that use case.',
    ),
    QuizQuestion(
      question: 'Which protocol fits internal robot-to-robot (service-to-service) calls needing high performance?',
      options: ['WebRTC', 'gRPC', 'Server-Sent Events', 'Plain email'],
      correctIndex: 1,
      explanation: 'gRPC\'s binary protobuf encoding and HTTP/2 transport suit high-performance internal service calls well.',
    ),
  ];

  static const _retriesBackoffJitter = [
    QuizQuestion(
      question: 'What does exponential backoff do between retry attempts?',
      options: ['Waits the same fixed amount of time every retry', 'Waits progressively longer between each attempt (e.g. doubling)', 'Retries instantly with no delay', 'Increases the request payload size each time'],
      correctIndex: 1,
      explanation: 'Growing the delay between attempts gives a struggling dependency room to recover instead of piling on more load.',
    ),
    QuizQuestion(
      question: 'What problem does adding jitter to backoff solve?',
      options: ['It makes retries happen faster', 'It prevents many clients that failed simultaneously from retrying in lockstep and recreating the same spike', 'It removes the need for a retry cap', 'It encrypts the retry request'],
      correctIndex: 1,
      explanation: 'Randomizing the wait spreads out retries that would otherwise all land at the same moment.',
    ),
    QuizQuestion(
      question: 'Why should retries always be capped with a maximum attempt count and timeout?',
      options: ['Caps are unnecessary if backoff is used', 'A truly dead dependency should eventually fail the caller instead of being retried forever', 'Capping retries makes requests faster', 'It has no real purpose'],
      correctIndex: 1,
      explanation: 'Without a cap, a permanently failing dependency would cause retries to continue indefinitely, wasting resources and delaying failure signals.',
    ),
    QuizQuestion(
      question: 'Why is it risky to retry a non-idempotent operation like "charge the credit card" by default?',
      options: ['It is never risky', 'A retry could cause the charge to be applied more than once unless paired with an idempotency key', 'Non-idempotent operations cannot be retried at all, technically', 'It only affects read operations'],
      correctIndex: 1,
      explanation: 'Retrying a side-effecting, non-idempotent call risks duplicating that effect unless idempotency is explicitly handled.',
    ),
    QuizQuestion(
      question: 'What is the "everyone redialing a busy line at once" scenario an analogy for?',
      options: ['A benefit of retries', 'The problem that immediate, synchronized retries from many clients can worsen an already-struggling dependency', 'A reason to avoid using backoff', 'A description of exactly-once delivery'],
      correctIndex: 1,
      explanation: 'This illustrates why naive immediate retries can amplify load on a struggling system instead of helping it recover.',
    ),
  ];

  static const _deliverySemantics = [
    QuizQuestion(
      question: 'What does at-most-once delivery guarantee?',
      options: ['A message is never lost and never duplicated', 'A message might be lost, but is never delivered more than once', 'A message is always delivered exactly one time, guaranteed', 'A message is always duplicated for safety'],
      correctIndex: 1,
      explanation: 'At-most-once is fire-and-forget: simplest, but accepts possible message loss.',
    ),
    QuizQuestion(
      question: 'What does at-least-once delivery require of the receiver?',
      options: ['Nothing special — duplicates are impossible', 'The receiver must tolerate and handle duplicate messages, usually via idempotency', 'The receiver must reject all retried messages', 'The receiver must always crash on duplicates'],
      correctIndex: 1,
      explanation: 'Since the sender retries until acknowledged, the receiver may see the same message more than once and must handle that safely.',
    ),
    QuizQuestion(
      question: 'What does "exactly-once" delivery actually mean in practice across a real network?',
      options: ['A magic transport-layer guarantee with zero duplicates ever', 'At-least-once delivery combined with idempotent processing on the receiving end', 'The same as at-most-once', 'It is theoretically impossible and never implemented'],
      correctIndex: 1,
      explanation: 'True exactly-once delivery isn\'t achievable at the transport layer alone; it\'s effectively at-least-once plus idempotency.',
    ),
    QuizQuestion(
      question: 'What is a Dead Letter Queue (DLQ) used for?',
      options: ['Storing successfully processed messages permanently', 'Catching messages that repeatedly fail processing, instead of blocking the queue or silently dropping them', 'Encrypting messages in transit', 'Load balancing across consumers'],
      correctIndex: 1,
      explanation: 'A DLQ isolates poison messages for inspection/reprocessing without stalling the rest of the queue.',
    ),
    QuizQuestion(
      question: 'What happens without a Dead Letter Queue when a message consistently fails processing?',
      options: ['Nothing changes, it is automatically fine', 'It could block the queue indefinitely or be silently and permanently lost, depending on the queue\'s retry behavior', 'The message automatically fixes itself', 'The consumer is guaranteed to crash safely'],
      correctIndex: 1,
      explanation: 'Without somewhere to route persistently failing messages, they either stall processing or vanish without a trace.',
    ),
  ];

  static const _healthChecksLivenessReadiness = [
    QuizQuestion(
      question: 'What question does a liveness check answer?',
      options: ['Should traffic be routed to this instance right now?', 'Is this process alive, or should it be restarted?', 'How much memory is available?', 'Is the database schema up to date?'],
      correctIndex: 1,
      explanation: 'Liveness is about whether the process itself needs to be killed and restarted.',
    ),
    QuizQuestion(
      question: 'What question does a readiness check answer?',
      options: ['Is this process alive?', 'Is this instance ready to take traffic right now?', 'Should the process be restarted?', 'How old is the deployed code?'],
      correctIndex: 1,
      explanation: 'Readiness is narrower — about routing eligibility, not process survival.',
    ),
    QuizQuestion(
      question: 'Why can a process be alive but not ready?',
      options: ['This scenario is impossible', 'It might still be starting up (loading data/warming a cache) or a dependency it needs might be temporarily down', 'Readiness and liveness always match exactly', 'Only databases can be unready'],
      correctIndex: 1,
      explanation: 'A perfectly healthy process can still be unable to serve traffic during startup or a dependency outage, without needing a restart.',
    ),
    QuizQuestion(
      question: 'What would go wrong if a system restarted an instance every time it failed a readiness check?',
      options: ['Nothing, this is the correct behavior', 'It could cause unnecessary restarts of otherwise-healthy instances that are just temporarily unready (e.g. still starting up)', 'It would improve startup time', 'It has no effect on availability'],
      correctIndex: 1,
      explanation: 'Conflating readiness with liveness risks restarting instances that just need a moment, delaying recovery further.',
    ),
    QuizQuestion(
      question: 'How does Kubernetes use liveness and readiness probes differently?',
      options: ['They are treated identically by Kubernetes', 'readinessProbe controls whether a Service routes traffic to the pod; livenessProbe controls whether the pod gets restarted', 'livenessProbe controls traffic routing; readinessProbe controls restarts', 'Kubernetes only supports one type of probe'],
      correctIndex: 1,
      explanation: 'Kubernetes explicitly separates these two probes to match their different purposes.',
    ),
  ];

  static const _gracefulDegradationDeployStrategies = [
    QuizQuestion(
      question: 'What is graceful degradation?',
      options: ['Showing a blank error page when anything fails', 'Falling back to a plain, working version of a feature instead of a full error when a non-critical part breaks', 'Automatically restarting the entire system', 'Deleting the failing feature permanently'],
      correctIndex: 1,
      explanation: 'Graceful degradation isolates a failure to just the affected feature, rather than breaking the whole page/experience.',
    ),
    QuizQuestion(
      question: 'What is the key tradeoff of a blue-green deployment?',
      options: ['It requires no extra infrastructure', 'It needs two complete environments (roughly double infrastructure cost) in exchange for instant traffic flip and instant rollback', 'It cannot support rollback at all', 'It is identical to a rolling deployment'],
      correctIndex: 1,
      explanation: 'Blue-green trades extra infrastructure cost for the safety of an instant, clean cutover and rollback.',
    ),
    QuizQuestion(
      question: 'How does a canary release limit risk?',
      options: ['By deploying to 100% of traffic immediately', 'By sending a small percentage of traffic to the new version, watching metrics, then ramping up gradually', 'By skipping monitoring entirely', 'By running the old version forever'],
      correctIndex: 1,
      explanation: 'Canary releases limit the blast radius of a bad release to a small slice of users before it reaches everyone.',
    ),
    QuizQuestion(
      question: 'What does a feature flag let you do that a deployment alone cannot?',
      options: ['Nothing different from a normal deploy', 'Turn a feature on or off at runtime without a redeploy, decoupling shipping code from activating behavior', 'Automatically fix bugs in the code', 'Bypass the need for testing entirely'],
      correctIndex: 1,
      explanation: 'Feature flags separate "the code is deployed" from "the behavior is active," giving a runtime kill switch.',
    ),
    QuizQuestion(
      question: 'What happens to running versions during a rolling deployment?',
      options: ['Only the new version ever runs, instantly', 'Old and new versions run simultaneously as instances are replaced batch by batch', 'The system goes fully offline during the rollout', 'Two complete separate environments are always required'],
      correctIndex: 1,
      explanation: 'Rolling deployments replace instances gradually, meaning mixed versions coexist for the duration of the rollout.',
    ),
  ];

  static const _chaosEngineering = [
    QuizQuestion(
      question: 'What is the core idea of chaos engineering?',
      options: ['Randomly breaking production with no plan or oversight', 'Deliberately injecting controlled failures to surface weaknesses on your own terms, rather than during a real incident', 'Avoiding all testing in favor of hoping for the best', 'Only testing in a fully isolated environment with no relation to production'],
      correctIndex: 1,
      explanation: 'Chaos engineering is controlled, hypothesis-driven failure injection, not random destruction.',
    ),
    QuizQuestion(
      question: 'What does Netflix\'s Chaos Monkey do?',
      options: ['Monitors CPU usage passively', 'Randomly terminates production instances to force services to tolerate real instance loss', 'Only runs in a staging environment, never production', 'Automatically fixes any bug it finds'],
      correctIndex: 1,
      explanation: 'Chaos Monkey is the best-known chaos engineering tool, specifically killing production instances at random.',
    ),
    QuizQuestion(
      question: 'What should a chaos engineering experiment start from?',
      options: ['No plan — pure randomness is the point', 'A specific hypothesis about how the system should behave under a given failure', 'A guarantee that nothing will go wrong', 'A requirement to test in production with zero blast radius control'],
      correctIndex: 1,
      explanation: 'Well-run chaos experiments test a specific expectation, rather than injecting failure without a clear question to answer.',
    ),
    QuizQuestion(
      question: 'Why start chaos experiments with a small blast radius?',
      options: ['Small blast radius has no practical benefit', 'To limit the impact if the experiment reveals a real, unexpected weakness', 'Because larger blast radii are always safer', 'Blast radius is not a consideration in chaos engineering'],
      correctIndex: 1,
      explanation: 'Starting small contains risk while still surfacing real issues, expanding scope only as confidence grows.',
    ),
    QuizQuestion(
      question: 'What is the ultimate goal of chaos engineering?',
      options: ['To cause as much downtime as possible', 'To find and fix resilience gaps proactively, before they cause a real unplanned incident', 'To replace all monitoring and alerting', 'To eliminate the need for circuit breakers'],
      correctIndex: 1,
      explanation: 'Chaos engineering exists to validate resilience assumptions deliberately, on a controlled schedule.',
    ),
  ];

  static const _cascadingFailuresThunderingHerd = [
    QuizQuestion(
      question: 'What is a cascading failure?',
      options: ['A failure contained entirely to one component with no other effects', 'An initial failure causing retries/timeouts that overload and fail neighboring components, spreading through the system', 'A planned maintenance window', 'A type of database index'],
      correctIndex: 1,
      explanation: 'Cascading failures spread because the response to the first failure (retries, timeouts) overloads healthy neighbors.',
    ),
    QuizQuestion(
      question: 'Which patterns exist specifically to prevent cascading failures?',
      options: ['Data normalization and denormalization', 'Circuit breakers, bulkheads, and backoff/jitter on retries', 'SQL indexing strategies', 'DNS caching'],
      correctIndex: 1,
      explanation: 'These resilience patterns are designed to stop one failure from propagating outward.',
    ),
    QuizQuestion(
      question: 'What is a thundering herd?',
      options: ['A gradual, staggered increase in traffic over hours', 'Every waiting request stampeding the origin at the exact same instant when a popular cache entry expires or a resource becomes unavailable', 'A type of database replication', 'A security attack involving SQL injection'],
      correctIndex: 1,
      explanation: 'Thundering herd describes synchronized demand overwhelming an origin all at once.',
    ),
    QuizQuestion(
      question: 'How does request coalescing help prevent a thundering herd?',
      options: ['By blocking all requests permanently', 'By having only one in-flight request per key go to the origin, while other simultaneous requests wait for that result', 'By duplicating every request to increase redundancy', 'By deleting the cache entirely'],
      correctIndex: 1,
      explanation: 'Coalescing collapses many simultaneous identical requests into a single origin call, sharing the result.',
    ),
    QuizQuestion(
      question: 'Why stagger cache TTLs across different keys?',
      options: ['It has no practical effect', 'So items don\'t all expire at the same moment, avoiding a synchronized stampede back to the origin', 'To make caching slower on purpose', 'To guarantee cache entries never expire'],
      correctIndex: 1,
      explanation: 'Spreading out expiration times avoids many keys triggering a thundering herd simultaneously.',
    ),
  ];

  static const _idGenerationSnowflakeUuid = [
    QuizQuestion(
      question: 'Why doesn\'t a simple auto-incrementing counter work for distributed ID generation?',
      options: ['Counters are too slow to compute', 'Multiple machines generating IDs independently would eventually produce the same number', 'Auto-increment cannot be used in any database', 'It uses too much storage'],
      correctIndex: 1,
      explanation: 'A shared counter needs central coordination; independent machines without it will eventually collide.',
    ),
    QuizQuestion(
      question: 'What is a limitation of UUID v4 for use as a database primary key?',
      options: ['It is not unique enough', 'It is not sortable and scatters randomly across a B-tree index, hurting index performance', 'It cannot be generated without a central server', 'It is too short to be useful'],
      correctIndex: 1,
      explanation: 'UUID v4\'s full randomness means related index pages are not created near each other, unlike a sortable ID.',
    ),
    QuizQuestion(
      question: 'What three components make up a Snowflake ID?',
      options: ['A random number, a checksum, and a version byte', 'A timestamp, a machine/worker ID, and a per-millisecond counter', 'A username, a password hash, and a salt', 'Only a random UUID with no structure'],
      correctIndex: 1,
      explanation: 'Snowflake IDs combine these three pieces to guarantee both uniqueness and rough time-ordering without coordination.',
    ),
    QuizQuestion(
      question: 'What advantage does a Snowflake ID have over a random UUID v4?',
      options: ['It is smaller in every case', 'It is naturally sortable by creation time, since the timestamp occupies the high-order bits', 'It requires a central coordinator to generate', 'It cannot be generated across multiple machines'],
      correctIndex: 1,
      explanation: 'Because the timestamp leads the ID, Snowflake IDs sort roughly in creation order — useful for pagination and indexing.',
    ),
    QuizQuestion(
      question: 'What is ULID designed to offer compared to a plain random UUID?',
      options: ['Less uniqueness guarantee', 'Time-sortability and compactness while remaining collision-resistant, splitting the difference between UUID and Snowflake', 'A requirement for centralized generation', 'Only support for numeric values'],
      correctIndex: 1,
      explanation: 'ULID keeps UUID-like properties but adds a leading timestamp for sortability.',
    ),
  ];

  static const _backOfEnvelopeEstimation = [
    QuizQuestion(
      question: 'Why do back-of-envelope estimates matter before designing a system?',
      options: ['They are purely a formality with no design impact', 'They reveal the order of magnitude of scale (e.g. 10 req/sec vs 100,000 req/sec), which drives completely different architecture choices', 'They replace the need for functional requirements', 'They are only relevant after the system is already built'],
      correctIndex: 1,
      explanation: 'The right architecture differs enormously depending on scale, so estimating it early avoids over- or under-engineering.',
    ),
    QuizQuestion(
      question: 'What is the typical first step in estimating request volume?',
      options: ['Guessing a random number', 'Converting a stated assumption (like DAU and actions per user per day) into requests per second', 'Skipping straight to database schema design', 'Assuming infinite scale by default'],
      correctIndex: 1,
      explanation: 'Requests/second is the foundational number that most other estimates and decisions build on.',
    ),
    QuizQuestion(
      question: 'How is rough yearly storage growth typically estimated?',
      options: ['It cannot be estimated in advance', 'Record size × records created per day × retention period', 'By guessing a fixed number regardless of scale', 'By only counting the size of the codebase'],
      correctIndex: 1,
      explanation: 'Multiplying per-record size by creation rate and retention gives a workable storage estimate.',
    ),
    QuizQuestion(
      question: 'Why does the read:write ratio matter for architecture decisions?',
      options: ['It has no bearing on design', 'A heavily read-dominant system (e.g. 100:1) benefits from aggressive caching in a way a write-heavy system does not', 'Read:write ratio only matters for security', 'Write-heavy systems never need a database'],
      correctIndex: 1,
      explanation: 'Knowing which side dominates tells you where to invest optimization effort — caching for reads, throughput for writes.',
    ),
    QuizQuestion(
      question: 'What is the actual goal of back-of-envelope estimation?',
      options: ['Producing numbers accurate to three significant figures', 'Order-of-magnitude sanity-checking that clearly rules an approach in or out, not precise numbers', 'Avoiding any numerical reasoning entirely', 'Calculating the exact salary budget for the team'],
      correctIndex: 1,
      explanation: 'The estimate just needs to be right enough to steer the design — precision beyond that is wasted effort.',
    ),
  ];

  static const _erasureCodingVsReplication = [
    QuizQuestion(
      question: 'What does simple replication do to protect against data loss?',
      options: ['Splits data into fragments with parity', 'Keeps multiple full copies of the data (commonly 3)', 'Deletes old data periodically', 'Compresses data to save space'],
      correctIndex: 1,
      explanation: 'Replication is straightforward: N complete copies of the same data.',
    ),
    QuizQuestion(
      question: 'What is the storage cost tradeoff of 3x replication?',
      options: ['No extra storage cost at all', 'It uses roughly 3 times the raw storage of a single copy', 'It uses less storage than a single copy', 'It requires exactly the same storage as erasure coding'],
      correctIndex: 1,
      explanation: 'N-way replication multiplies storage by N to achieve its fault tolerance.',
    ),
    QuizQuestion(
      question: 'How does erasure coding achieve fault tolerance more storage-efficiently than replication?',
      options: ['By keeping 5 full copies instead of 3', 'By splitting data into fragments plus parity fragments, reconstructable from any large-enough subset', 'By never storing any redundant data', 'By using a faster network protocol'],
      correctIndex: 1,
      explanation: 'Erasure coding needs far less overhead than full copies to tolerate the same number of failures.',
    ),
    QuizQuestion(
      question: 'What does erasure coding cost in exchange for its storage savings?',
      options: ['Nothing — it is strictly better in every way', 'More CPU work to reconstruct data from fragments on read', 'It cannot tolerate any failures', 'It requires manual intervention for every read'],
      correctIndex: 1,
      explanation: 'Reconstructing from fragments takes computation that a direct read of an intact replica does not need.',
    ),
    QuizQuestion(
      question: 'When do object storage systems typically favor erasure coding over replication?',
      options: ['For frequently accessed hot data needing the lowest possible latency', 'For cold/archival data where storage cost matters more than reconstruction latency', 'Erasure coding is never used in object storage', 'Only for data under 1KB in size'],
      correctIndex: 1,
      explanation: 'Erasure coding\'s storage savings pay off most where access is infrequent and CPU cost of reconstruction is a lesser concern.',
    ),
  ];

  static const _semanticVectorSearch = [
    QuizQuestion(
      question: 'Why can full-text search fail to connect "sneakers" with "running shoes"?',
      options: ['Full-text search is broken by design', 'It matches on exact shared words, and these two phrases share no literal words', 'Full-text search only works with numbers', 'The words are too short to index'],
      correctIndex: 1,
      explanation: 'Keyword-based search relies on literal term overlap, which purely synonymous phrases may lack entirely.',
    ),
    QuizQuestion(
      question: 'What is a vector embedding?',
      options: ['A compressed image file format', 'A point in high-dimensional space representing text/image content, where similar meanings land close together', 'A type of database index for exact matches', 'A network routing table'],
      correctIndex: 1,
      explanation: 'Embeddings map content into a space where geometric closeness reflects semantic similarity.',
    ),
    QuizQuestion(
      question: 'How does semantic search find relevant results?',
      options: ['By scanning for exact keyword matches only', 'By performing a nearest-neighbor query over vectors in embedding space', 'By randomly sampling the document set', 'By sorting alphabetically'],
      correctIndex: 1,
      explanation: 'Semantic search retrieves whatever content\'s embedding is closest to the query\'s embedding.',
    ),
    QuizQuestion(
      question: 'What do Approximate Nearest Neighbor (ANN) algorithms like HNSW trade off?',
      options: ['They guarantee perfect accuracy with zero performance cost', 'A small amount of accuracy for much faster nearest-neighbor search at scale versus an exact scan', 'They only work for exact keyword matching', 'They eliminate the need for embeddings entirely'],
      correctIndex: 1,
      explanation: 'ANN algorithms sacrifice some precision to make nearest-neighbor search practical at large scale.',
    ),
    QuizQuestion(
      question: 'What is "hybrid search"?',
      options: ['Using only vector search and never keyword search', 'Combining keyword (full-text) and vector search, blending their rankings, since exact matches still matter alongside semantic ones', 'A search index that only works offline', 'A deprecated search technique no longer used'],
      correctIndex: 1,
      explanation: 'Hybrid search blends both approaches since exact matches (like a SKU or name) and semantic matches both have value.',
    ),
  ];

  static const _requirementsGatheringTradeoffs = [
    QuizQuestion(
      question: 'What should typically be gathered first in a system design discussion?',
      options: ['The exact database schema', 'Functional requirements — the concrete features/use cases the system must support', 'The final deployment infrastructure', 'The API rate limits'],
      correctIndex: 1,
      explanation: 'Understanding what the system needs to do comes before deciding how it will do it.',
    ),
    QuizQuestion(
      question: 'What do non-functional requirements typically cover?',
      options: ['The exact button colors in the UI', 'Scale (DAU/QPS), latency targets, consistency model, availability target, and durability', 'Only the programming language to use', 'The company\'s org chart'],
      correctIndex: 1,
      explanation: 'Non-functional requirements are the "how well" constraints that shape architecture and capacity decisions.',
    ),
    QuizQuestion(
      question: 'Why state assumptions out loud rather than silently guessing?',
      options: ['It has no practical benefit', 'A stated assumption can be corrected by an interviewer or stakeholder; a silent one cannot', 'It slows down the discussion unnecessarily', 'Assumptions should never be made at all'],
      correctIndex: 1,
      explanation: 'Voicing assumptions gives others the chance to correct a wrong premise before it shapes the whole design.',
    ),
    QuizQuestion(
      question: 'What distinguishes a senior-level design answer from a list of technologies?',
      options: ['Using the most technologies possible', 'Explicitly naming trade-offs — what is being optimized for and what is being given up — tied back to the actual requirements', 'Avoiding any mention of trade-offs entirely', 'Only using the newest available tools'],
      correctIndex: 1,
      explanation: 'Reasoning connects each choice to the requirements; a bare list of tech names does not demonstrate that reasoning.',
    ),
    QuizQuestion(
      question: 'What is the recommended balance between building for the future and avoiding over-engineering?',
      options: ['Always build for the largest possible scale from day one', 'Build so today\'s decisions don\'t force an unnecessary teardown later, without over-engineering for scale that may never arrive', 'Never consider future scale at all', 'Rewrite the system from scratch every year'],
      correctIndex: 1,
      explanation: 'The goal is avoiding painful rework later without wasting effort solving problems that do not yet exist.',
    ),
  ];
}
