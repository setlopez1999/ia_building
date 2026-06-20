import '../../models/game_server_target_dto.dart';

class GameServerDataSource {
  final Map<String, List<GameServerTargetDto>> gameTargets = {
    'cs2': [
      const GameServerTargetDto(target: '155.133.244.51', name: 'Valve Lima', location: 'Lima'),
      const GameServerTargetDto(target: '155.133.249.179', name: 'Valve Santiago', location: 'Santiago'),
      const GameServerTargetDto(target: '155.133.227.67', name: 'Valve Sao Paulo', location: 'Sao Paulo'),
      const GameServerTargetDto(target: '155.133.255.254', name: 'Valve Buenos Aires', location: 'Buenos Aires'),
      const GameServerTargetDto(target: '205.196.6.210', name: 'Valve Seattle', location: 'Seattle'),
      const GameServerTargetDto(target: '162.254.193.71', name: 'Valve Chicago', location: 'Chicago'),
      const GameServerTargetDto(target: '162.254.194.54', name: 'Valve Dallas', location: 'Dallas'),
    ],
    'valorant': [
      const GameServerTargetDto(target: 'ae1.er01.mex01.riotdirect.net', name: 'Bogotá Edge', location: 'Bogota'),
      const GameServerTargetDto(target: 'te-0-0-0-35-0.er02.sao02.riotdirect.net', name: 'BR Sao Paulo', location: 'Sao Paulo'),
      const GameServerTargetDto(target: 'te-0-0-0-20-0.er01.scl02.riotdirect.net', name: 'Santiago Edge', location: 'Santiago'),
      const GameServerTargetDto(target: 'er01.mia02.riotdirect.net', name: 'US Miami', location: 'Miami'),
      const GameServerTargetDto(target: 'ae1.er02.bog01.riotdirect.net', name: 'Mexico City', location: 'Mexico City'),
    ],
    'dota2': [
      const GameServerTargetDto(target: 'dynamodb.us-east-1.amazonaws.com', name: 'US East', location: 'Virginia'),
      const GameServerTargetDto(target: 'dynamodb.us-west-1.amazonaws.com', name: 'US West', location: 'California'),
      const GameServerTargetDto(target: 'dynamodb.eu-central-1.amazonaws.com', name: 'Europe West', location: 'Frankfurt'),
      const GameServerTargetDto(target: 'dynamodb.sa-east-1.amazonaws.com', name: 'Brasil', location: 'Sao Paulo'),
    ],
    'fortnite': [
      const GameServerTargetDto(target: 'ec2-52-67-110-115.sa-east-1.compute.amazonaws.com', name: 'AWS Sao Paulo', location: 'Sao Paulo'),
      const GameServerTargetDto(target: 'ec2-3-231-193-126.compute-1.amazonaws.com', name: 'US East (Virginia)', location: 'Virginia'),
      const GameServerTargetDto(target: 'ec2-18-116-102-234.us-east-2.compute.amazonaws.com', name: 'US East (Ohio)', location: 'Ohio'),
      const GameServerTargetDto(target: 'ec2-44-240-118-24.us-west-2.compute.amazonaws.com', name: 'US West (Oregon)', location: 'Oregon'),
    ],
    'pubg': [
      const GameServerTargetDto(target: 'ec2-52-67-110-115.sa-east-1.compute.amazonaws.com', name: 'PUBG SA', location: 'Sao Paulo'),
      const GameServerTargetDto(target: 'dynamodb.us-east-1.amazonaws.com', name: 'PUBG NA', location: 'Iowa'),
    ],
  };

  List<GameServerTargetDto> getTargets(String gameId) => gameTargets[gameId] ?? [];

  String? getTargetForGame(String gameId) {
    final targets = getTargets(gameId);
    return targets.isNotEmpty ? targets.first.target : null;
  }
}
