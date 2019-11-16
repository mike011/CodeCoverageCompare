A tool written in Swift for macOS to present in a simple format the result of running `xcrun xccov diff`

Here is what the output will look like:

|Change|File|Develop|PR|
|------|----|-------|--|
|👎|ExistingClassCoverageDown|<a href=http://www.nba.com/ExistingClassCoverageDown.swift.html>100%</a>|<a href=http://www.espn.com/ExistingClassCoverageDown.swift.html>50%</a>|
|🚫|ExistingClassCoverageDropped|<a href=http://www.nba.com/ExistingClassCoverageDropped.swift.html>100%</a>|<a href=http://www.espn.com/ExistingClassCoverageDropped.swift.html>0%</a>|
|👍|ExistingClassCoverageUp|<a href=http://www.nba.com/ExistingClassCoverageUp.swift.html>33%</a>|<a href=http://www.espn.com/ExistingClassCoverageUp.swift.html>67%</a>|
|💯|ExistingClassCovered|<a href=http://www.nba.com/ExistingClassCovered.swift.html>100%</a>|<a href=http://www.espn.com/ExistingClassCovered.swift.html>100%</a>|
|🚫|ExistingClassNotCovered|<a href=http://www.nba.com/ExistingClassNotCovered.swift.html>0%</a>|<a href=http://www.espn.com/ExistingClassNotCovered.swift.html>0%</a>|
|💯|NewClassCovered|<a href=http://www.nba.com/NewClassCovered.swift.html>0%</a>|<a href=http://www.espn.com/NewClassCovered.swift.html>100%</a>|
|🚫|NewClassNoCoverage|<a href=http://www.nba.com/NewClassNoCoverage.swift.html>0%</a>|<a href=http://www.espn.com/NewClassNoCoverage.swift.html>0%</a>|
|💯|ExistingClassCoverageDownTests|<a href=http://www.nba.com/ExistingClassCoverageDownTests.swift.html>100%</a>|<a href=http://www.espn.com/ExistingClassCoverageDownTests.swift.html>100%</a>|
|🚫|ExistingClassCoverageDroppedTests|<a href=http://www.nba.com/ExistingClassCoverageDroppedTests.swift.html>100%</a>|<a href=http://www.espn.com/ExistingClassCoverageDroppedTests.swift.html>0%</a>|
|💯|ExistingClassCoverageUpTests|<a href=http://www.nba.com/ExistingClassCoverageUpTests.swift.html>100%</a>|<a href=http://www.espn.com/ExistingClassCoverageUpTests.swift.html>100%</a>|
|💯|ExistingClassCoveredTests|<a href=http://www.nba.com/ExistingClassCoveredTests.swift.html>100%</a>|<a href=http://www.espn.com/ExistingClassCoveredTests.swift.html>100%</a>|
|💯|NewClassCoveredTests|<a href=http://www.nba.com/NewClassCoveredTests.swift.html>0%</a>|<a href=http://www.espn.com/NewClassCoveredTests.swift.html>100%</a>|
