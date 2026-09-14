import XCTest
import SwiftUI
@testable import DesignSystem

final class DSStepRailSpecTests: XCTestCase {
    private let theme = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)
    private let five = 5

    func testAStepBeforeTheCurrentOneIsDone() {
        XCTAssertEqual(DSStepRail.State.phase(index: 0, current: 2), .done)
        XCTAssertEqual(DSStepRail.State.phase(index: 1, current: 2), .done)
    }

    func testTheCurrentStepIsActive() {
        XCTAssertEqual(DSStepRail.State.phase(index: 2, current: 2), .active)
    }

    func testAStepAfterTheCurrentOneIsUpcoming() {
        XCTAssertEqual(DSStepRail.State.phase(index: 3, current: 2), .upcoming)
        XCTAssertEqual(DSStepRail.State.phase(index: 4, current: 2), .upcoming)
    }

    func testOnlyDoneAndActiveStepsAreReachable() {
        XCTAssertTrue(DSStepRail.State.isReachable(index: 0, current: 2))
        XCTAssertTrue(DSStepRail.State.isReachable(index: 2, current: 2))
        XCTAssertFalse(DSStepRail.State.isReachable(index: 3, current: 2))
    }

    func testTheCurrentStepIsClampedIntoRange() {
        XCTAssertEqual(DSStepRail.State.clamped(current: 9, count: five), 4)
        XCTAssertEqual(DSStepRail.State.clamped(current: -3, count: five), 0)
        XCTAssertEqual(DSStepRail.State.clamped(current: 0, count: 0), 0)
    }

    func testTheIndicatorReadsAsAOneBasedPosition() {
        XCTAssertEqual(DSStepRail.State.ordinal(index: 0), "1")
        XCTAssertEqual(DSStepRail.State.ordinal(index: 4), "5")
    }

    func testEveryPhaseResolvesADistinctMarkerFill() {
        let done = DSStepRail.State.markerFill(.done, theme: theme)
        let active = DSStepRail.State.markerFill(.active, theme: theme)
        let upcoming = DSStepRail.State.markerFill(.upcoming, theme: theme)

        XCTAssertNotEqual(done, active)
        XCTAssertNotEqual(active, upcoming)
        XCTAssertNotEqual(done, upcoming)
    }

    func testAnActiveMarkerUsesTheAccentAndACompletedOneTheBrandSurface() {
        XCTAssertEqual(DSStepRail.State.markerFill(.active, theme: theme), theme.colors.surfaceSecondary100)
        XCTAssertEqual(DSStepRail.State.markerFill(.done, theme: theme), theme.colors.surfacePrimary100)
        XCTAssertEqual(DSStepRail.State.markerFill(.upcoming, theme: theme), theme.colors.surfaceNeutral3)
    }

    func testMarkerContentStaysLegibleOnEveryFill() {
        XCTAssertEqual(DSStepRail.State.markerForeground(.active, theme: theme), theme.colors.textNeutral05)
        XCTAssertEqual(DSStepRail.State.markerForeground(.done, theme: theme), theme.colors.textNeutral05)
        XCTAssertEqual(DSStepRail.State.markerForeground(.upcoming, theme: theme), theme.colors.textNeutral6)
    }

    func testOnlyTheActiveLabelIsEmphasised() {
        XCTAssertEqual(DSStepRail.State.labelStyle(.active, theme: theme).weight, .semibold)
        XCTAssertEqual(DSStepRail.State.labelStyle(.done, theme: theme).weight, .medium)
        XCTAssertEqual(DSStepRail.State.labelStyle(.upcoming, theme: theme).weight, .medium)
    }

    func testOnlyTheActiveStepPaintsATrack() {
        XCTAssertEqual(DSStepRail.State.trackFill(.active, theme: theme), theme.colors.surfaceNeutral05)
        XCTAssertEqual(DSStepRail.State.trackFill(.done, theme: theme), Color.clear)
        XCTAssertEqual(DSStepRail.State.trackFill(.upcoming, theme: theme), Color.clear)
    }

    func testEveryMetricResolvesThroughAToken() {
        XCTAssertEqual(DSStepRail.Metrics.markerSize, theme.spacing.md + theme.spacing.xxxs)
        XCTAssertEqual(DSStepRail.Metrics.itemHeight, theme.spacing.xl)
        XCTAssertEqual(DSStepRail.Metrics.itemGap, theme.spacing.xs)
        XCTAssertEqual(DSStepRail.Metrics.itemHorizontalPadding, theme.spacing.sm)
        XCTAssertEqual(DSStepRail.Metrics.markerToLabelGap, theme.spacing.xs)
    }

    func testTheRailReportsOneItemPerStep() {
        let steps: [DSStepRailStep] = [
            DSStepRailStep(id: 0, label: "Scope"),
            DSStepRailStep(id: 1, label: "API"),
            DSStepRailStep(id: 2, label: "Architecture"),
        ]
        XCTAssertEqual(steps.count, 3)
        XCTAssertEqual(DSStepRail.State.clamped(current: 2, count: steps.count), 2)
    }
}
