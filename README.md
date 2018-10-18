<h1> DCAS </h1>
<p>Part of coding work I have done in DCAS. Including code for Company Classification and Checkbook API.</p>

<h3>Company Classification?</h2>
<p>Project description: This is the first step of one of my projects @DCAS. The goal is to use 'business description'(column in the dataset) to classify those M/WBE company into four classes: Construction Services, Goods, Professional Services and Standardized Services. My training data come from the MWBE dataset can be downloaded from nyc open data and some other from my colleague. NLTK Similarity, Naive Bayes, SVM and KNN as well as K-means are tried here and SVM is the one be selected with up to 90% out-sample accuracy. </p>
<p>Keywords: text mining, classification, imbalanced data.</p>

<p>Data source: https://data.cityofnewyork.us/Business/M-WBE-LBE-and-EBE-Certified-Business-List/ci93-uc8s. Some of the datasets are provided by DCAS employee which cannot be accessed from open sourse. (So it may not work if you do not have these)</p>

<p>Packages used: pandas, numpy, nltk, imblearn and sklearn, please install first when you run the code.</p>

<p>Reference: (1) For imbalance data resample: http://contrib.scikit-learn.org/imbalanced-learn/stable/combine.html (2) For machine learning part: http://scikit-learn.org/stable/tutorial/text_analytics/working_with_text_data.html </p>
<p></p>
<h3>Checkbook NYC API</h3>
<p>By using the API, you can get all data present in Checkbook NYC: https://www.checkbooknyc.com/</p>
<p>This is a xml format based API, all the request would be sent and received with xml format. And for each call you can get up to 1000 records. The detailed description of this API is at: https://www.checkbooknyc.com/data-feeds/api</p>
<p>What I have done here, for the python code, is a class which create a dataframe with ALL the data that meet your criteria finally(if you got 3000 data which meet your criteria, then it will loop 3 times to get you all of the data.). What you should do is to first intitial the search criteria dictionary(ex: year=2019) at the first part by entering values to the dictionary which have been created. You can also do no change at this part and just initialize the dictionary and plug it into the class, which will give you all the results - but it will take a long time.</p>
<p>Example:</p>
<ul><li>Step1: Initialize search criteria.</li>
<li>Step2: checkbook_nyc_api = checkbook_nyc(search_criteria=search_criteria,type_name='Spending') #Initialize the class</li>
<li>Step3: result = checkbook_nyc_api.formatted_data() #formatted_data is the function which get the final result</li></ul>

<p>Also, I have a R code version for the checkbook API here too. Although I just write a small demo for only DCAS data in fiscal year 2019, it will be a reference for you to grab other data since I haven't found a R code version before.</p>
