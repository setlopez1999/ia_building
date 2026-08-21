enum PlayerSteps {
  none,
  controls,
  epg,
  channels,
  catchup,
  catchupControls,
  chromecastSelector,
  chromecastLoading,
  cameraList,
  cameraGrid,
  cameraEvents,
  cameraInfo,
  cameraAlert,
}

enum CatchupStatus {
  notStarted,
  playing,
  finished
}

enum PlayerStatus {
  playing,
  error,
  buffering
}