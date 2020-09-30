#include <iostream>
#include <math.h>
#include <string>
#include <Eigen/Dense>

#include "Observer.h"

using namespace std;
using namespace Eigen;


double x_old = 0.0;
double y_old = 0.0;
double t_old = 0.0;

double y_hat = 0.0;
double u = 0.0;

VectorXd A_out(2);
VectorXd x_hat_old(2);

MatrixXd A(2, 2);
MatrixXd B(2, 1);
MatrixXd C(1, 2);

MatrixXd L(2, 1);
MatrixXd K(1, 2);

Observer::Observer()
{
	A << 0.8859, -0.1282,
		0.0943, 0.9935;

	B << 0.0943,
		0.0048;

	C << 0.0, 1.5069;

	L << 14.7298,
		1.9955;

	K << -0.6397, -0.7573;

	A_out(0) = 0.0;
	A_out(1) = 0.0;

	x_hat_old(0) = 0.0;
	x_hat_old(1) = 0.0;
}


//Observer::~Observer()
//{
//}

double Observer::Lqr_Obs(double y, double t)
{
	VectorXd L_out(2);
	VectorXd Sum_out(2);
	VectorXd x_hat(2);

	L_out = L * -(y_hat - y);
	Sum_out = L_out + B * u + A_out;
	x_hat = Sum_out * (t - t_old) + x_hat_old;
	A_out = A * x_hat;

	x_hat_old = x_hat;

	// Because the result is a 1x1 matrix, it cant be convertet directly to a double
	// The matrix in itself is an array, so the desired value can be extracted by 
	// indexing the value from the array. 
	y_hat = (C * x_hat)(0);

	return (K * x_hat)(0);
}

