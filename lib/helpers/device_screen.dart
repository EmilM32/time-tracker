/// mobile - width <= 768
///
/// tablet - width > 768 && width <= 1024
///
/// desktop - width > 1024
enum Screens {
  mobile,
  tablet,
  desktop,
}

double kMaxMobileWidth = 768;
double kMaxTabletWidth = 1024;

Screens getDeviceScreen(double width) {
  if (width <= kMaxMobileWidth) {
    return Screens.mobile;
  } else if (width <= kMaxTabletWidth) {
    return Screens.tablet;
  } else {
    return Screens.desktop;
  }
}
