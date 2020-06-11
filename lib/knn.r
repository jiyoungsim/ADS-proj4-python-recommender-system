feature <- function(p, q, data_train, data_test){


#load original data
ratings = read.csv('../data/ml-latest-small/ratings.csv')
colnames(p) = sort(unique(ratings$userId))
colnames(q) = sort(unique(ratings$movieId))
#distance matrix given q
simi <- function(Q, diag = 1){
  mag_fron = apply(Q, 2, function(q)return(sqrt(sum(q^2))))
  simi = (t(Q)%*%Q) / (mag_fron%*%t(mag_fron))
  diag(simi) = diag
  return(simi)
}
#distance of items
NN = simi(q, 0)
colnames(NN) = colnames(q)
rownames(NN) = colnames(q)
#matrix of original predictor PQ
orig_pred = t(p) %*% q
knn = matrix(NA, dim(orig_pred)[1], dim(orig_pred)[2])
colnames(knn) = colnames(q)
rownames(knn) = colnames(p)
#matrix of knn predictor
#1 min run time
for(i in 1:dim(p)[2]){
  nn = data_train[data_train$userId==i,]
  nn_list = as.character(nn[,2])
  ri = nn[apply(NN[nn_list,], 2, which.max),3]
  knn[i,] = ri
}
#regression terms p^tq and knn
#1 min run time
user_train = as.character(data_train$userId)
movie_train = as.character(data_train$movieId)
x_orig = c()
x_knn = c()
for(i in 1:dim(data_train)[1]){
  x_orig = c(x_orig, orig_pred[user_train[i], movie_train[i]])
  x_knn = c(x_knn, knn[user_train[i], movie_train[i]])
}
#regression model:
#rating ~ p^tq + knn
reg_knn = lm(data_train$rating ~ x_orig + x_knn)
#test
#1 min run time
user_test = as.character(data_test$userId)
movie_test = as.character(data_test$movieId)
test_x_orig = c()
test_x_knn = c()
for(i in 1:dim(data_test)[1]){
  test_x_orig = c(test_x_orig, orig_pred[user_test[i], movie_test[i]])
  test_x_knn = c(test_x_knn, knn[user_test[i], movie_test[i]])
}
#test rmse
#original rmse
test_rmse_orig = sqrt(mean((data_test$rating - test_x_orig)^2))
#with knn rmse
r_knn = coef(reg_knn)[1] + coef(reg_knn)[2] * test_x_orig + coef(reg_knn)[3] * test_x_knn
test_rmse_knn = sqrt(mean((data_test$rating - r_knn)^2))

return(list(reg_coef = coef(reg_knn),
            rmse_orig = test_rmse_orig,
            rmse_test = test_rmse_knn))
}