function[TestData, FitResults] =  Driver(file, sheet, radius, vs, seg_sizes, skip, CSM, SearchSegEnd)

TestData = LoadTest(file, sheet, radius, vs, skip, CSM);
FitResults = SingleSearchAllSegments(seg_sizes, TestData, SearchSegEnd);
end