import 'system_design.dart';

/// A single system design *theory* topic — the fundamentals hellointerview
/// covers (networking, databases, caching, scaling, etc.) independent of any
/// specific case study. Each concept is a short written explanation plus an
/// optional pre-drawn architecture diagram illustrating the idea, using the
/// same component vocabulary as the design canvas.
class FundamentalConcept {
  final String id;
  final String category;
  final String title;
  final String summary;
  final List<String> keyPoints;
  final ReferenceArchitecture? diagram;
  final String? diagramCaption;

  const FundamentalConcept({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.keyPoints,
    this.diagram,
    this.diagramCaption,
  });
}
