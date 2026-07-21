import 'package:flutter/material.dart';

/// The palette of components a user can drag onto the design canvas.
/// Kept intentionally small and generic (rather than one icon per problem)
/// so the same palette works across every system design problem.
enum ComponentType {
  client('Client', Icons.smartphone),
  loadBalancer('Load Balancer', Icons.call_split),
  apiServer('API Server', Icons.dns_outlined),
  database('Database', Icons.storage_outlined),
  cache('Cache', Icons.flash_on_outlined),
  cdn('CDN', Icons.public),
  messageQueue('Message Queue', Icons.swap_horiz),
  objectStorage('Object Storage', Icons.folder_outlined),
  idGenerator('ID Generator', Icons.tag),
  webSocketServer('WebSocket Server', Icons.cable_outlined);

  final String label;
  final IconData icon;
  const ComponentType(this.label, this.icon);
}

/// A component placed by the user (or the reference solution) on the canvas.
class PlacedComponent {
  final String id;
  final ComponentType type;
  Offset position;

  PlacedComponent({
    required this.id,
    required this.type,
    required this.position,
  });
}

/// A directed edge between two placed components, by id.
class Connection {
  final String fromId;
  final String toId;

  const Connection({required this.fromId, required this.toId});
}

/// The reference architecture a problem is checked against: which component
/// *types* should exist and which type-to-type edges should connect them.
/// Checked structurally (by type), not by exact position or instance id, so
/// there's no single "correct" layout the user has to guess.
class ReferenceArchitecture {
  final List<ComponentType> components;
  final List<(ComponentType, ComponentType)> connections;

  const ReferenceArchitecture({
    required this.components,
    required this.connections,
  });
}

class SystemDesignProblem {
  final String id;
  final String title;
  final String difficulty; // 'Easy', 'Medium', 'Hard'
  final String prompt;
  final List<String> functionalRequirements;
  final List<String> nonFunctionalRequirements;
  final List<String> capacityEstimation;
  final List<String> apiDesign;
  final String highLevelDesign;
  final ReferenceArchitecture reference;

  const SystemDesignProblem({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.prompt,
    required this.functionalRequirements,
    required this.nonFunctionalRequirements,
    required this.capacityEstimation,
    required this.apiDesign,
    required this.highLevelDesign,
    required this.reference,
  });
}
