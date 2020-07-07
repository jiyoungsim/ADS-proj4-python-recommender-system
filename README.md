# Collaborative Filtering and Post-processing for Recommender Systems (Project Lead)

+ **Team members**
	+ Project Lead: Sim, Young
	+ Sohn, Jongyoon
	+ Gao, Xin
	+ Yang, Siyu
	+ Meng, Yang
	
+ **Keywords: Recommender System, Collaborative Filtering, Probabilistic Matrix Factorization, Post-processing, K Nearest Neighbors (KNN), Kernel Ridge Regression, Python**

+ **Objectives**: The goal of this project build recommender systems based on probabilistic matrix factorization with applications of two different post-processing methods: KNN and kernel ridge regression. Through comparison of each model’s performance, we evaluate which model performs the best for the purpose of collaborative filtering.

+ **Summary**: Collaborative filtering refers to the process of making automatic predictions (filtering) about the interests of a user by collecting preferences or taste information from many users (collaborating). In this project, we use probabilistic matrix factorization for collaborative filtering with movie ratings data to build recommender engines. The project estimates latent factors by gradient descent to create user-factor matrix and item-factor matrix. See project notebook for more details.

	<img src="/figs/matrix_factorization.png" width="600">
	
	The below graph shows change in RMSE as we train more epochs for models with number of latent factors 10 and 20.
	
	<img src="/figs/RMSE.png" width="600">

	We can see that the gradient descent algorithm is working successfully as RMSE gets lower as we train more epochs. Different number of features show only slight change in RMSE.

	For post-processing, we used KNN and Kernel Ridge Regression to construct the second regression terms to improve the model. For KNN, we define similarity between two movies as the cosine similarity between vectors representing the two movies. Then we use the average rating of most similar movie as prediction. For kernel ridge regression, define y as user specific ratings. X consists of normalized vector of factors for movies rated by the user in each row. Using y and X, we solve Kernel Ridge Regression. Using linear regression, we combine the predictions from PMF and each post-processed predictions. Then we use RMSE to evaluate the combined models.

	<img src="/figs/boxplot.png" width="600">

	The predictions are higher when the actual ratings are higher. The betas for KNN predictions and KRR predictions are very small, so knn_processed_preds and krr_processed_preds, which are linear regression of each with PMF predictions, consist mostly of PMF predictions. Accordingly, the box plots for the two are very similar, and knn_processed_preds and krr_processed_preds are highly correlated.

	<img src="/figs/results.png" width="600">

	From the results above, we can observe that KRR post-processed results are better off by 0.01 RMSE compared to PMF predictions. The test RMSE for the KRR predictions is lower than train RMSE, indicating that the model may be underfitting and has more room to improve. We used the same parameters as given in the paper for this model, but with parameter tuning we may get better results. On the other hand, KNN post-processed results are similar to PMF (worse off by 0.0005 RMSE). A possible explanation is that we use K=1 so the KNN predictions only depend on a single nearest item. This may have caused noised due to overfitting and have evened out the ensemble effect. Also, we are not given ratings for every movie in the first place, and more movies have been omitted as we set the KNN prediction to 0 for movies without ratings. Accordingly, almost half of the test prediction with KNN was set to 0. KNN may perform better with more data available and/or with larger K.

+ **References**:
	+ [Salakhutdinov, R. & Mnih, A. Probabilistic matrix factorization.](https://github.com/jiyoungsim/ADS-proj4-python-recommender-system/blob/master/doc/papers/probabilistic-matrix-factorization.pdf)
	+ [Paterek, A. (2007). Improving regularized singular value decomposition for collaborative filtering. KDDCup.07.](https://github.com/jiyoungsim/ADS-proj4-python-recommender-system/blob/master/doc/papers/Improving%20regularized%20singular%20value%20decomposition%20for%20collaborative%20filtering%20.pdf)


	
+ **Contribution statement**: All team members approve our work presented in this GitHub repository including this contributions statement. 
	+ Young wrote final deliverables in Python: PMF, KNN, and Kernel Ridge Regression algorithms and the main script (doc/PMF_model.py and doc/PMF_main.ipynb). She also presented the project.
	+ Jongyoon created slides for presentation (doc/Probabilistic Matrix Factorization.pdf) and worked on parameter tuning.
	+ Xin worked on PMF in R (lib/other work/Matrix Factorization1.R) and parameter tuning.
	+ Siyu worked on KNN in R (lib/other work/knn other version.Rmd) and parameter tuning.
	+ Yang worked on KNN in R (lib/other work/knn.Rmd), KNN function for R and python (knn.R) and parameter tuning.
	

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── data/ data used in the analysis. 
├── doc/ final deliverables such as the model, report, and presentation files.
├── figs/ figures.
├── lib/ other work done in process.
└── output/ processed datasets.
```

Please see each subfolder for a README file.
