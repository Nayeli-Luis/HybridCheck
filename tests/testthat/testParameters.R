context("Parameter storing objects")

test_that("sequence similarity scan parameters set and return settings correctly.", {
  settingsObj <- HybridCheck:::SSAnalysisSettings$new()
  expect_equal(settingsObj$getWindowSize(), 100L)
  expect_is(settingsObj$getWindowSize(), "integer")
  expect_equal(settingsObj$getStepSize(), 1L)
  expect_is(settingsObj$getStepSize(), "integer")
  expect_error(settingsObj$setWindowSize("a"))
  expect_error(settingsObj$setWindowSize(c("a", "b", "c")))
  expect_error(settingsObj$setWindowSize(1))
  expect_error(settingsObj$setWindowSize(c(1, 2, 3)))
  expect_error(settingsObj$setWindowSize(c(1L, 2L, 3L)))
  expect_error(settingsObj$setSettings(WindowSize = 500, StepSize = 2))
  expect_error(settingsObj$setSettings(WindowSize = 500, StepSize = 2L))
  expect_error(settingsObj$setSettings(WindowSize = 500L, StepSize = 2))
  expect_error(settingsObj$setSettings(WindowSize = c(500, 600), StepSize = c(2, 5)))
  expect_error(settingsObj$setSettings(WindowSize = 500, StepSize = c(2, 5)))
  expect_error(settingsObj$setSettings(WindowSize = c(500, 600), StepSize = 2))
  expect_error(settingsObj$setSettings(WindowSize = c(500L, 600L), StepSize = c(2L, 5L)))
  expect_error(settingsObj$setSettings(WindowSize = 500L, StepSize = c(2L, 5L)))
  expect_error(settingsObj$setSettings(WindowSize = c(500L, 600L), StepSize = 2L))
  settingsObj$setSettings(WindowSize = 500L, StepSize = 2L)
  expect_equal(settingsObj$getWindowSize(), 500L)
  expect_equal(settingsObj$getStepSize(), 2L)
  expect_is(settingsObj$getWindowSize(), "integer")
  expect_is(settingsObj$getStepSize(), "integer")
})

test_that("block detection parameters object sets and returns values correctly.", {
  settingsObj <- HybridCheck:::BlockDetectionSettings$new()
  expect_equal(settingsObj$ManualThresholds, 90)
  expect_is(settingsObj$ManualThresholds, "numeric")
  expect_true(settingsObj$AutoThresholds)
  expect_is(settingsObj$AutoThresholds, "logical")
  expect_true(settingsObj$ManualFallback)
  expect_is(settingsObj$ManualFallback, "logical")
  expect_equal(settingsObj$SDstringency, 2)
  expect_is(settingsObj$SDstringency, "numeric")
  expect_error(settingsObj$setManualThresholds("hi"))
  expect_error(settingsObj$setManualThresholds(-2))
  expect_error(settingsObj$setManualThresholds(150))
  expect_error(settingsObj$setSDstringency(0))
  settingsObj$setSettings(AutoThresholds = FALSE, ManualFallback = FALSE)
  expect_false(settingsObj$AutoThresholds)
  expect_false(settingsObj$ManualFallback)
  settingsObj$setSDstringency(5)
  expect_equal(settingsObj$SDstringency, 5)
})

test_that("block significance test and dating settings object sets and returns settings correctly.", {
  settingsObj <- HybridCheck:::BlockDatingSettings$new()
  expect_is(settingsObj$MutationRate, "numeric")
  expect_is(settingsObj$PValue, "numeric")
  expect_is(settingsObj$BonfCorrection, "logical")
  expect_is(settingsObj$DateAnyway, "logical")
  expect_is(settingsObj$MutationCorrection, "character")
  expect_equal(settingsObj$MutationRate, 10e-9)
  expect_equal(settingsObj$PValue, 0.005)
  expect_true(settingsObj$BonfCorrection)
  expect_false(settingsObj$DateAnyway)
  expect_equal(settingsObj$MutationCorrection, "JC69")
  expect_error(settingsObj$setMutationRate("hi"))
  expect_error(settingsObj$setMutationRate(c("hi", "ho")))
  expect_error(settingsObj$setMutationRate(c(10e-8, 10e-7)))
  expect_error(settingsObj$setPValue("hi"))
  expect_error(settingsObj$setPValue(c("hi", "ho")))
  expect_error(settingsObj$setPValue(c(0.001, 0.05)))
  expect_error(settingsObj$setBonferonni("hi"))
  expect_error(settingsObj$setBonferonni(5))
  expect_error(settingsObj$setBonferonni(5L))
  expect_error(settingsObj$setDateAnyway(5))
  expect_error(settingsObj$setDateAnyway("hi"))
  expect_error(settingsObj$setDateAnyway(5L))
  expect_error(settingsObj$setMutationCorrection(5L))
  expect_error(settingsObj$setMutationCorrection("hi"))
  settingsObj$setMutationCorrection("raw")
  settingsObj$setMutationRate(10e-6)
  settingsObj$setPValue(0.001)
  settingsObj$setBonferonni(FALSE)
  settingsObj$setDateAnyway(TRUE)
  expect_equal(settingsObj$MutationCorrection, "raw")
  expect_equal(settingsObj$MutationRate, 10e-6)
  expect_equal(settingsObj$PValue, 0.001)
  expect_false(settingsObj$BonfCorrection)
  expect_true(settingsObj$DateAnyway)
})

test_that("comparrison settings reference object sets and returns settings correctly.", {
  data(MySequences)
  dna <- HybridCheck:::HCseq$new(MySequences)
  ftt <- HybridCheck:::FTTester$new(dna)
  expect_warning(compSettings <- HybridCheck:::ComparrisonSettings$new(dna, ftt))
  expect_equal(compSettings$TripletCombinations, combn(dna$getSequenceNames(), 3, simplify = FALSE))
  expect_equal(compSettings$AcceptedCombinations, combn(dna$getSequenceNames(), 3, simplify = FALSE))
  expect_equal(compSettings$SeqNames, dna$getSequenceNames())
  expect_equal(compSettings$Method, 1L)
  expect_equal(compSettings$DistanceThreshold, 0.01)
  expect_equal(compSettings$PartitionStrictness, 2L)
  expect_equal(length(compSettings$TripletCombinations), 120)
  expect_equal(length(compSettings$AcceptedCombinations), 120)
  expect_error(compSettings$changeMethod(1))
  expect_error(compSettings$changeMethod(c(1, 2)))
  expect_error(compSettings$changeMethod(c(-1, 5)))
  expect_error(compSettings$changeMethod(-5))
  expect_error(compSettings$changeMethod(0L))
  expect_error(compSettings$changeMethod(5L))
  expect_error(compSettings$changeMethod(c(3L, 4L)))
  compSettings$changeMethod(c(3L))
  expect_equal(compSettings$Method, c(3L))
  expect_error(compSettings$setDistanceThreshold(c("hi", "bye")))
  expect_error(compSettings$setDistanceThreshold(c(1L, 2L)))
  expect_error(compSettings$setDistanceThreshold(c(FALSE, TRUE)))
  expect_error(compSettings$setDistanceThreshold(FALSE))
  expect_error(compSettings$setDistanceThreshold("hi"))
  expect_error(compSettings$setDistanceThreshold(2))
  expect_error(compSettings$setDistanceThreshold(-2))
  expect_error(compSettings$setDistanceThreshold(1.1))
  compSettings$setDistanceThreshold(0.02)
  expect_equal(compSettings$DistanceThreshold, 0.02)
  expect_error(compSettings$setPartitionStrictness("hi"))
  expect_error(compSettings$setPartitionStrictness(1))
  expect_error(compSettings$setPartitionStrictness(2))
  expect_error(compSettings$setPartitionStrictness(3))
  expect_error(compSettings$setPartitionStrictness(3L))
  expect_error(compSettings$setPartitionStrictness(c(1L, 2L)))
  compSettings$setPartitionStrictness(1L)
  expect_equal(compSettings$PartitionStrictness, 1L)
  compSettings$decideAcceptedTriplets(dna, ftt)
  expect_less_than(length(compSettings$AcceptedCombinations), length(compSettings$TripletCombinations))
})



