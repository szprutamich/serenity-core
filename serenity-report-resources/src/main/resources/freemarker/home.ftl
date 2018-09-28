<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>

    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Serenity Reports</title>

    <#include "libraries/favicon.ftl">

    <#include "libraries/common.ftl">
    <#include "libraries/jquery-ui.ftl">
    <#include "libraries/datatables.ftl">

    <#include "components/tag-list.ftl">
    <#include "components/test-outcomes.ftl">


<#assign manualTests = testOutcomes.count("manual")>
<#assign automatedTests = testOutcomes.count("automated")>

<#assign testResultData = resultCounts.byTypeFor("success","pending","ignored","skipped","failure","error","compromised") >
<#assign testLabels = resultCounts.percentageLabelsByTypeFor("success","pending","ignored","skipped","failure","error","compromised") >
<#assign graphType="automated-and-manual-results"/>

<#assign successfulManualTests = (manualTests.withResult("SUCCESS") > 0)>
<#assign pendingManualTests = (manualTests.withResult("PENDING") > 0)>
<#assign ignoredManualTests = (manualTests.withResult("IGNORED") > 0)>
<#assign failingManualTests = (manualTests.withResult("FAILURE") > 0)>

    <script class="code" type="text/javascript">$(document).ready(function () {


        $('.scenario-result-table').DataTable({

            "order": [[0, "asc",], [3, "asc",]],
            "pageLength": 25,
            "language": {
                searchPlaceholder: "Filter",
                search: ""
            }
        });

        // Results table
        $('#test-results-table').DataTable({
            "order": [[0, "asc",], [3, "asc",]],
            "pageLength": 100,
            "lengthMenu": [[25, 50, 100, 200, -1], [25, 50, 100, 200, "All"]]
        });

    })
    ;
    </script>
</head>

<body class="results-page">
<div id="topheader">
    <div id="topbanner">
        <div id="logo"><a href="index.html"><img src="images/serenity-logo.png" border="0"/></a></div>
        <div id="projectname-banner" style="float:right">
            <span class="projectname">${reportOptions.projectName}</span>
        </div>
    </div>
</div>

<div class="middlecontent">

<#assign tagsTitle = 'Related Tags' >
<#if (testOutcomes.label == '')>
    <#assign resultsContext = ''>
    <#assign pageTitle = 'Test Results: All Tests' >
<#else>
    <#assign resultsContext = '> ' + testOutcomes.label>

    <#if (currentTagType! != '')>
        <#assign pageTitle = "<i class='fa fa-tags'></i> " + inflection.of(currentTagType!"").asATitle() + ': ' +  inflection.of(testOutcomes.label).asATitle() >
    <#else>
        <#assign pageTitle = inflection.of(testOutcomes.label).asATitle() >
    </#if>
</#if>
    <div id="contenttop">
    <#--<div class="leftbg"></div>-->
        <div class="middlebg">
        <span class="breadcrumbs"><a href="index.html">Home</a>
        <#if (parentTag?has_content && parentTag.name! != '')>
            <#assign titleContext = " (with " + inflection.of(parentTag.type!"").asATitle() + " " + inflection.of(parentTag.name!"").asATitle() + ")" >
        <#else>
            <#assign titleContext = "" >
        </#if>
        <#if (breadcrumbs?has_content)>
            <#list breadcrumbs as breadcrumb>
                <#assign breadcrumbReport = absoluteReportName.forRequirementOrTag(breadcrumb) />
                <#assign breadcrumbTitle = inflection.of(breadcrumb.shortName).asATitle() >
                <#assign breadcrumbType = inflection.of(breadcrumb.type).asATitle() >
                > <a href="${breadcrumbReport}" title="${breadcrumbTitle} (breadcrumbType)">
                    <#--${formatter.htmlCompatible(breadcrumbTitle)}-->
                        ${formatter.htmlCompatibleStoryTitle(breadcrumbTitle)}
                </a>
            </#list>
        <#else>
            <#if currentTagType?has_content>
                > ${inflection.of(currentTagType!"").asATitle()} ${titleContext}
            </#if>
        </#if>
            <#if testOutcomes.label?has_content>
            <#--> ${formatter.truncatedHtmlCompatible(inflection.of(testOutcomes.label).asATitle(),60)}-->
                > <span
                    class="truncate-60">${formatter.htmlCompatibleStoryTitle(inflection.of(testOutcomes.label).asATitle())}</span>
            </#if>
        </span>
        </div>
        <div class="rightbg"></div>
    </div>

    <div class="clr"></div>
    <!--/* starts second table*/-->
<#include "menu.ftl">
<@main_menu selected="home" />
    <div class="clr"></div>
    <div id="beforetable"></div>
    <div id="results-dashboard">
        <div class="middlb">
            <div class="table">

                <h2>${pageTitle}</h2>
                <table class='overview'>
                    <tr>
                        <td width="375px" valign="top">
                            <div class="test-count-summary">
                <span class="test-count-title">${testOutcomes.totalTestScenarios}
                    test scenarios <#if (testOutcomes.hasDataDrivenTests())>(${testOutcomes.total} tests in all, including ${testOutcomes.totalDataRows}
                    rows of test data)</#if></span>
                                <div>
            <#assign successReport = reportName.withPrefix(currentTag).forTestResult("success") >
            <#assign brokenReport = reportName.withPrefix(currentTag).forTestResult("broken") >
            <#assign failureReport = reportName.withPrefix(currentTag).forTestResult("failure") >
            <#assign errorReport = reportName.withPrefix(currentTag).forTestResult("error") >
            <#assign compromisedReport = reportName.withPrefix(currentTag).forTestResult("compromised") >
            <#assign pendingReport = reportName.withPrefix(currentTag).forTestResult("pending") >
            <#assign skippedReport = reportName.withPrefix(currentTag).forTestResult("skipped") >
            <#assign ignoredReport = reportName.withPrefix(currentTag).forTestResult("ignored") >

            <#assign totalCount   = testOutcomes.totalScenarios.total >
            <#assign successCount = testOutcomes.totalScenarios.withResult("success") >
            <#assign pendingCount = testOutcomes.totalScenarios.withResult("pending") >
            <#assign ignoredCount = testOutcomes.totalScenarios.withResult("ignored") >
            <#assign skippedCount = testOutcomes.totalScenarios.withResult("skipped") >
            <#assign failureCount = testOutcomes.totalScenarios.withResult("failure") >
            <#assign errorCount   = testOutcomes.totalScenarios.withResult("error") >
            <#assign brokenCount  = failureCount + errorCount >
            <#assign compromisedCount = testOutcomes.totalScenarios.withResult("compromised") >
            <#assign badTestCount  = failureCount + errorCount + compromisedCount>

                <#if (successCount > 0)>
                    <span class="test-count"> |
                        ${successCount}
                        <#if (report.shouldDisplayResultLink)>
                            <a href="${relativeLink}${successReport}">passed</a>
                        <#else>passed</#if>
                    </span>
                </#if>
                <#if (pendingCount > 0)>
                    <span class="test-count"> |
                        ${pendingCount}
                        <#if (report.shouldDisplayResultLink)>
                            <a href="${relativeLink}${pendingReport}">pending</a>
                        <#else>pending</#if>
                    </span>
                </#if>
                <#if (brokenCount > 0)>
                    <span class="test-count"> |
                        ${brokenCount}
                        <#if (report.shouldDisplayResultLink)>
                            <a href="${relativeLink}${brokenReport}">unsuccessful</a>
                        <#else>unsuccessful</#if>
                    </span>(
                    <span class="test-count">
                        ${failureCount}
                        <#if (report.shouldDisplayResultLink)>
                            <a href="${relativeLink}${failureReport}">failed</a>
                        <#else>failed</#if>,
                    </span>
                    <span class="test-count">
                        ${errorCount}
                        <#if (report.shouldDisplayResultLink && errorCount gt 0)>
                            <a href="${relativeLink}${errorReport}">with errors</a>
                        <#else>errors</#if>
                    </span>)
                </#if>

                <#if (compromisedCount > 0)> |
                    <span class="test-count">
                        ${compromisedCount}
                        <#if (report.shouldDisplayResultLink)>
                            <a href="${relativeLink}${compromisedReport}">compromised tests</a>
                        <#else>compromised</#if>
                    </span>
                </#if>

                <#if (ignoredCount > 0)>
                    <span class="test-count"> |
                        ${ignoredCount}
                        <#if (report.shouldDisplayResultLink)>
                            <a href="${relativeLink}${ignoredReport}">ignored</a>
                        <#else>ignored</#if>
                    </span>
                </#if>

                <#if (skippedCount > 0)>
                <span class="test-count"> |
                    ${skippedCount}
                    <#if (skippedCount > 0 && report.shouldDisplayResultLink)>
                        <a href="${relativeLink}${skippedReport}">skipped</a>
                    <#else>skipped</#if>
                </span>
                </#if>

                <#if testOutcomes.haveFlags()>
                    <span class="test-count"> |
                        <#list testOutcomes.flags as flag>
                            <#assign flagTitle = inflection.of(flag.message).inPluralForm().asATitle() >
                            <#assign flagTag = "flag_${inflection.of(flag.message).asATitle()}" >
                            <#assign flagReport = reportName.forTag(flagTag) >
                            <#assign flagCount = testOutcomes.flagCountFor(flag)>
                            <i class="fa fa fa-${flag.symbol} flag-color" alt="${flag.message}"
                               title="${flag.message}"></i> <a href="${flagReport}">${flagTitle}</a> (${flagCount})
                        </#list>
                    </span>
                </#if>

                <#if (csvReport! != '')> |
                    <a href="${csvReport}" title="Download CSV"> <i class="fa fa-download" title="Download CSV"></i></a>
                </#if>
                                </div>
                            </div>

                            <div>
                                <ul class="nav nav-tabs">
                                    <li class="active">
                                        <a data-toggle="tab" href="#summary"><i class="fas fa-home"></i> Summary</a>
                                    </li>
                                    <li>
                                        <a data-toggle="tab" href="#tests"><i class="fas fa-tachometer-alt"></i> Test
                                            Results</a>
                                    </li>
                                </ul>


                                <div class="card border">
                                    <div class="tab-content" id="pills-tabContent">
                                        <div id="summary" class="tab-pane fade in active">
                                            <div class="container-fluid">
                                                <div class="row">
                                                    <div class="col-sm-4">
                                                        <div style="width:300px;" class="chart-container ${graphType}">
                                                            <div class="ct-chart ct-square"></div>
                                                        </div>
                                                        <script>

                                                            var labels = ${testLabels};
                                                            // Our series array that contains series objects or in this case series data arrays

                                                            var series = ${testResultData};

                                                            // As options we currently only set a static size of 300x200 px. We can also omit this and use aspect ratio containers
                                                            // as you saw in the previous example
                                                            var options = {
                                                                width: 350,
                                                                height: 300
                                                            };


                                                            new Chartist.Pie('.ct-chart', {
                                                                series: series,
                                                                labels: labels
                                                            }, {
                                                                plugins: [ Chartist.plugins.tooltip() ],
                                                                donut: true,
                                                                donutWidth: 60,
                                                                donutSolid: true,
                                                                startAngle: 270,
                                                                showLabel: true
                                                            }, options);


                                                            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                                                                new Chartist.Pie('.ct-chart', {
                                                                    series: series,
                                                                    labels: labels
                                                                }, {
                                                                    plugins: [ Chartist.plugins.tooltip() ],
                                                                    donut: true,
                                                                    donutWidth: 60,
                                                                    donutSolid: true,
                                                                    startAngle: 270,
                                                                    showLabel: true
                                                                }, options);
                                                            });


                                                        </script>
                                                    </div>
                                                    <div class="col-sm-8">

                                                        <table class="table">
                                                            <thead>
                                                            <tr>
                                                                <th scope="col">Scenarios</th>
                                                                <th scope="col" colspan="2" class="automated-stats">
                                                                    Automated
                                                                </th>
                                                    <#if resultCounts.hasManualTests() >
                                                        <th scope="col" colspan="2" class="manual-stats"> Manual</th>
                                                        <th scope="col" colspan="2" class="total-stats"> Total</th>
                                                    </#if>
                                                            </tr>
                                                            </thead>
                                                            <tbody>
                                                            <tr>
                                                                <#if (resultCounts.getOverallTestCount("success") != 0)>
                                                                    <td class="aggregate-result-count">
                                                                        <a href="${successReport}"><i class='fa fa-check-circle-o success-icon'></i>&nbsp;Passing</a>
                                                                    </td>
                                                                <#else>
                                                                    <td class="aggregate-result-count"><i
                                                                            class='fa fa-check-circle-o success-icon'></i>&nbsp;Passing
                                                                    </td>
                                                                </#if>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestCount("success")}</td>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestPercentage("success")}</td>
                                                                <#if resultCounts.hasManualTests() >
                                                                <td class="manual-stats">${resultCounts.getManualTestCount("success")}</td>
                                                                <td class="manual-stats">${resultCounts.getManualTestPercentage("success")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestCount("success")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestPercentage("success")}</td>
                                                                </#if>
                                                            </tr>
                                                            <tr>
                                                                <#if (resultCounts.getOverallTestCount("pending") != 0)>
                                                                    <td class="aggregate-result-count">
                                                                        <a href="${pendingReport}"><i class='fa fa-stop-circle-o pending-icon'></i>&nbsp;Pending</a>
                                                                    </td>
                                                                <#else>
                                                                    <td class="aggregate-result-count"><i
                                                                            class='fa fa-stop-circle-o pending-icon'></i>&nbsp;Pending
                                                                    </td>
                                                                </#if>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestCount("pending")}</td>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestPercentage("pending")}</td>
                                                                <#if resultCounts.hasManualTests() >
                                                                <td class="manual-stats">${resultCounts.getManualTestCount("pending")}</td>
                                                                <td class="manual-stats">${resultCounts.getManualTestPercentage("pending")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestCount("pending")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestPercentage("pending")}</td>
                                                                </#if>
                                                            </tr>
                                                            <tr>
                                                                <#if (resultCounts.getOverallTestCount("ignored") != 0)>
                                                                    <td class="aggregate-result-count">
                                                                        <a href="${ignoredReport}"><i class='fa fa-ban ignored-icon'></i>&nbsp;Ignored</a>
                                                                    </td>
                                                                <#else>
                                                                <td class="aggregate-result-count"><i
                                                                        class='fa fa-ban ignored-icon'></i>&nbsp;Ignored
                                                                </td>
                                                                </#if>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestCount("ignored")}</td>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestPercentage("ignored")}</td>
                                                                <#if resultCounts.hasManualTests() >
                                                                <td class="manual-stats">${resultCounts.getManualTestCount("ignored")}</td>
                                                                <td class="manual-stats">${resultCounts.getManualTestPercentage("ignored")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestCount("ignored")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestPercentage("ignored")}</td>
                                                                </#if>
                                                            </tr>
                                                            <tr>
                                                                <#if (resultCounts.getOverallTestCount("skipped") != 0)>
                                                                    <td class="aggregate-result-count">
                                                                        <a href="${skippedReport}"><i class='fa fa-fast-forward skip-icon'></i>&nbsp;Skipped</a>
                                                                    </td>
                                                                <#else>
                                                                <td class="aggregate-result-count"><i
                                                                        class='fa fa-fast-forward skip-icon'></i>&nbsp;Skipped
                                                                </td>
                                                                </#if>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestCount("skipped")}</td>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestPercentage("skipped")}</td>
                                                                <#if resultCounts.hasManualTests() >
                                                                <td class="manual-stats">${resultCounts.getManualTestCount("skipped")}</td>
                                                                <td class="manual-stats">${resultCounts.getManualTestPercentage("skipped")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestCount("skipped")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestPercentage("skipped")}</td>
                                                                </#if>
                                                            </tr>
                                                            <tr>
                                                                <#if (resultCounts.getOverallTestCount("failure") != 0)>
                                                                    <td class="aggregate-result-count">
                                                                        <a href="${failureReport}"><i class='fa fa-times-circle failure-icon'></i>&nbsp;Failed</a>
                                                                    </td>
                                                                <#else>
                                                                <td class="aggregate-result-count"><i
                                                                        class='fa fa-times-circle failure-icon'></i>&nbsp;Failed
                                                                </td>
                                                                </#if>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestCount("failure")}</td>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestPercentage("failure")}</td>
                                                                <#if resultCounts.hasManualTests() >
                                                                <td class="manual-stats">${resultCounts.getManualTestCount("failure")}</td>
                                                                <td class="manual-stats">${resultCounts.getManualTestPercentage("failure")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestCount("failure")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestPercentage("failure")}</td>
                                                                </#if>
                                                            <tr>
                                                                <#if (resultCounts.getOverallTestCount("error") != 0)>
                                                                    <td class="aggregate-result-count">
                                                                        <a href="${errorReport}"><i class='fa fa-exclamation-triangle error-icon'></i>&nbsp;Broken</a>
                                                                    </td>
                                                                <#else>
                                                                <td class="aggregate-result-count"><i
                                                                        class='fa fa-exclamation-triangle error-icon'></i>&nbsp;Broken
                                                                </td>
                                                                </#if>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestCount("error")}</td>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestPercentage("error")}</td>
                                                                <#if resultCounts.hasManualTests() >
                                                                <td class="manual-stats">${resultCounts.getManualTestCount("error")}</td>
                                                                <td class="manual-stats">${resultCounts.getManualTestPercentage("error")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestCount("error")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestPercentage("error")}</td>
                                                                </#if>
                                                            <tr>
                                                                <#if (resultCounts.getOverallTestCount("compromised") != 0)>
                                                                    <td class="aggregate-result-count">
                                                                        <a href="${compromisedReport}"><i class='fa fa-chain-broken compromised-icon'></i>&nbsp;Compromised</a>
                                                                    </td>
                                                                <#else>
                                                                <td class="aggregate-result-count"><i
                                                                        class='fa fa-chain-broken compromised-icon'></i>&nbsp;Compromised
                                                                </td>
                                                                </#if>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestCount("compromised")}</td>
                                                                <td class="automated-stats">${resultCounts.getAutomatedTestPercentage("compromised")}</td>
                                                                <#if resultCounts.hasManualTests() >
                                                                <td class="manual-stats">${resultCounts.getManualTestCount("compromised")}</td>
                                                                <td class="manual-stats">${resultCounts.getManualTestPercentage("compromised")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestCount("compromised")}</td>
                                                                <td class="total-stats">${resultCounts.getOverallTestPercentage("compromised")}</td>
                                                                </#if>
                                                            </tr>
                                                            <tr class="summary-stats">
                                                                <td class="aggregate-result-count">Total</td>
                                                                <td class="automated-stats">${resultCounts.getTotalAutomatedTestCount()}</td>
                                                                <td class="automated-stats"></td>
                                                            <#if resultCounts.hasManualTests() >
                                                            <td class="manual-stats">${resultCounts.getTotalManualTestCount()}</td>
                                                            <td class="manual-stats"></td>
                                                            <td class="total-stats">${resultCounts.getTotalOverallTestCount()}</td>
                                                            <td class="total-stats"></td>
                                                            </#if>
                                                            </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>


                                                <#if coverage?has_content>
                                                <div class="row">
                                                    <div class="col-sm-12">
                                                        <h3>Functional Coverage Overview</h3>

                                                        <#list coverage as tagCoverageByType>
                                                            <#if tagCoverageByType.tagCoverage?has_content>
                                                            <table class="table" id="${tagCoverageByType.tagType}">
                                                                <thead>
                                                                    <tr>
                                                                        <th>${tagCoverageByType.tagType}</th>
                                                                        <th style=""width:7.5em;">Scenarios</th>
                                                                        <th style=""width:7.5em;">% Pass</th>
                                                                        <th style=""width:7.5em;">Result</th>
                                                                        <th>Coverage</th>
                                                                    </tr>
                                                                </thead>
                                                                <#assign tageCoverageEntries = tagCoverageByType.tagCoverage />
                                                                <tbody>
                                                                    <#list tageCoverageEntries as tagCoverage>
                                                                    <tr>
                                                                        <td><a href="${tagCoverage.report}">${tagCoverage.tagName}</a></td>
                                                                        <td>${tagCoverage.testCount}</td>
                                                                        <td>${tagCoverage.successRate}</td>
                                                                        <td>${tagCoverage.resultIcon}</td>
                                                                        <td>
                                                                            <div class="progress">
                                                                                <#list tagCoverage.coverageSegments as coverageSegment>
                                                                                    <div class="progress-bar" role="progressbar"
                                                                                         style="width: ${coverageSegment.percentage}%; background-color: ${coverageSegment.color}"
                                                                                         aria-valuenow="${coverageSegment.count}"
                                                                                         title="${coverageSegment.title}"
                                                                                         aria-valuemin="0"
                                                                                         aria-valuemax="100">
                                                                                    </div>
                                                                                </#list>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    </#list>
                                                                </tbody>
                                                            </table>
                                                            </#if>
                                                        </#list>
                                                    </div>
                                                </div>
                                                </#if>

                                                <#if badTestCount != 0>
                                                <div class="row">
                                                    <div class="col-sm-6">
                                                        <h3>Test Failure Overview</h3>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-sm-6">
                                                        <h4>Most Frequent Failures</h4>

                                                        <table class="table">
                                                            <tbody>
                                                            <#list frequentFailures as frequentFailure>
                                                            <tr>
                                                                <td class="${frequentFailure.resultClass}-color top-list-title">${frequentFailure.resultIcon} ${frequentFailure.name}</td>
                                                                <td><span class="badge failure-badge">${frequentFailure.count}</span></td>
                                                            </tr>
                                                            </#list>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <div class="col-sm-6">
                                                        <h4>Most Unstable Features</h4>
                                                        <table class="table">
                                                            <tbody>
                                                                <#list unstableFeatures as unstableFeature>
                                                                <tr>
                                                                    <td class="failure-color top-list-title"><a href="${unstableFeature.report}">${unstableFeature.name}</a></td>
                                                                    <td><span class="badge failure-badge">${unstableFeature.failureCount}</span></td>
                                                                </tr>
                                                                </#list>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                                </#if>

                                                <#if tagResults?has_content >
                                                <div class="row">
                                                    <div class="col-sm-12">
                                                        <h3>Tags</h3>

                                                        <#list tagResults as tagResult >
                                                        <span>
                                                            <a href="${tagResult.report}">
                                                                <span class="badge" style="background-color:${tagResult.color}; margin:1em;padding:4px;"><i class="fa fa-tag"></i> ${tagResult.label}&nbsp;&nbsp;&nbsp;${tagResult.count}</span>
                                                            </a>
                                                        </span>
                                                        </#list>
                                                    </div>
                                                </div>
                                                </#if>
                                            </div>
                                        </div>
                                        <div id="tests" class="tab-pane fade">
                                            <div class="container-fluid">
                                                <div class="row">
                                                    <div class="col-sm-12">
                                                        <h3><i class="fas fa-cogs"></i> Automated Tests</h3>

                                            <#if (automatedTestCases?has_content)>
                                            <table class="scenario-result-table table" id="scenario-results">
                                                <thead>
                                                <tr>
                                                    <th>${leafRequirementType}</th>
                                                    <th class="test-name-column">Scenario</th>
                                                    <th>Steps</th>
                                                    <th>Start Time</th>
                                                    <th>Duration</th>
                                                    <th>Result</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <#list automatedTestCases as scenario>
                                                    <#assign outcome_icon = formatter.resultIcon().forResult(scenario.result) />
                                                <tr class="scenario-result ${scenario.result}">
                                                    <td>
                                                        <#if scenario.parentName?has_content>
                                                            <a href="${scenario.parentReport}">${scenario.parentName}</a>
                                                        </#if>
                                                    </td>
                                                    <td>
                                                        <a href="${scenario.scenarioReport}">${scenario.title}</a>
                                                               <#if scenario.hasExamples() >
                                                                   (${scenario.numberOfExamples})
                                                               </#if>
                                                    </td>
                                                    <td>${scenario.stepCount}</td>
                                                    <td>${scenario.formattedStartTime}</td>
                                                    <td>${scenario.formattedDuration}</td>
                                                    <td>${outcome_icon} <span style="display:none">${scenario.result}</span></td>
                                                </tr>
                                                </#list>
                                                </tbody>
                                            </table>
                                            <#else>
                                            No automated tests were executed
                                            </#if>

                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-sm-12">
                                                        <h3><i class="fas fa-edit"></i> Manual Tests</h3>

                                            <#if (manualTestCases?has_content)>
                                            <table class="scenario-result-table table" id="manual-scenario-results">
                                                <thead>
                                                <tr>
                                                    <th>${leafRequirementType}</th>
                                                    <th class="test-name-column" style="width:60em;">Scenario</th>
                                                    <th>Steps</th>
                                                    <th>Result</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <#list manualTestCases as scenario>
                                                    <#assign outcome_icon = formatter.resultIcon().forResult(scenario.result) />
                                                <tr>
                                                    <td>
                                                        <#if scenario.parentName?has_content>
                                                            <a href="${scenario.parentReport}">${scenario.parentName}</a>
                                                        </#if>
                                                    </td>
                                                    <td>
                                                        <a href="${scenario.scenarioReport}">${scenario.title}</a>
                                                        <#if scenario.hasExamples() >
                                                           (${scenario.numberOfExamples})
                                                        </#if>
                                                    </td>
                                                    <td>${scenario.stepCount}</td>
                                                    <td>${outcome_icon} <span
                                                            style="display:none">${scenario.result}</span></td>
                                                </tr>
                                                </#list>
                                                </tbody>
                                            </table>
                                            <#else>
                                                No manual tests were recorded
                                            </#if>

                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                        </td>

                    </tr>
                </table>

            </div>
        </div>
    </div>
</div>
<div id="beforefooter"></div>

<div class="container-fluid">
    <div class="row">
        <div class="col-sm-12">
            <span class="version">Serenity BDD version ${serenityVersionNumber}</span>
        </div>
    </div>
</div>


</body>
</html>
