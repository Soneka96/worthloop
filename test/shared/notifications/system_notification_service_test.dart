// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/shared/notifications/Inotification.gateway.dart';
import 'package:worth_loop/shared/notifications/system_notification_service.dart';

class MockINotificationGateway extends Mock implements INotificationGateway {}

void main() {
  late MockINotificationGateway mockGateway;
  late SystemNotificationService service;

  setUp(() {
    mockGateway = MockINotificationGateway();
    service = SystemNotificationService(mockGateway);
  });

  group('SystemNotificationService behaves correctly', () {
    test(
      'Method initialize() calls INotificationGateway.setup() with "Clean Architecture Starter"',
      () async {
        when(() => mockGateway.setup(any())).thenAnswer((_) async {});

        await service.initialize();

        verify(
          () => mockGateway.setup('Clean Architecture Starter'),
        ).called(1);
      },
    );

    test(
      'Method show() calls INotificationGateway.show() with the given title, body, actionLabels, onClick, and onActionClicked',
      () async {
        void onClick() {}
        void onActionClicked(int index) {}
        when(
          () => mockGateway.show(
            title: any(named: 'title'),
            body: any(named: 'body'),
            actionLabels: any(named: 'actionLabels'),
            onClick: any(named: 'onClick'),
            onActionClicked: any(named: 'onActionClicked'),
          ),
        ).thenAnswer((_) async => 'notification-1');

        await service.show(
          title: 'Restart pending',
          body: 'The app needs to restart to finish moving your data.',
          actionLabels: const ['Restart now'],
          onClick: onClick,
          onActionClicked: onActionClicked,
        );

        verify(
          () => mockGateway.show(
            title: 'Restart pending',
            body: 'The app needs to restart to finish moving your data.',
            actionLabels: const ['Restart now'],
            onClick: onClick,
            onActionClicked: onActionClicked,
          ),
        ).called(1);
      },
    );

    test(
      'Method closeActive() calls INotificationGateway.close() with the identifier returned by the last show()',
      () async {
        when(
          () => mockGateway.show(
            title: any(named: 'title'),
            body: any(named: 'body'),
            actionLabels: any(named: 'actionLabels'),
            onClick: any(named: 'onClick'),
            onActionClicked: any(named: 'onActionClicked'),
          ),
        ).thenAnswer((_) async => 'notification-1');
        when(() => mockGateway.close(any())).thenAnswer((_) async {});
        await service.show(title: 'Restart pending');

        await service.closeActive();

        verify(() => mockGateway.close('notification-1')).called(1);
      },
    );

    test(
      'Method closeActive() does not call INotificationGateway.close() when nothing has been shown yet',
      () async {
        await service.closeActive();

        verifyNever(() => mockGateway.close(any()));
      },
    );

    test(
      'Method show() closes the previously shown notification before showing the new one',
      () async {
        when(
          () => mockGateway.show(
            title: any(named: 'title'),
            body: any(named: 'body'),
            actionLabels: any(named: 'actionLabels'),
            onClick: any(named: 'onClick'),
            onActionClicked: any(named: 'onActionClicked'),
          ),
        ).thenAnswer((_) async => 'notification-1');
        when(() => mockGateway.close(any())).thenAnswer((_) async {});
        await service.show(title: 'First');

        await service.show(title: 'Second');

        verify(() => mockGateway.close('notification-1')).called(1);
      },
    );
  });
}
