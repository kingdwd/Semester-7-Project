// parameters: 
//		* matrix: A, B, C, L, K
//		* scalar: Ki
// input: ref, y

// global variables:
// y_hat = 0
// u = 0
// A_out = 0
// y_old = 0
// int_i_old = 0
// Sum_out_old = 0
// matrix A, B, C, L, K, Ki


// ref = 1;
// y = speed(x,y,t)
// int_i = (ref - y) + int_i_old
// u = Lqr_Obs(y) + int_i * Ki
// if u > 3:
//		u = 3

// publish(u)

//int_i_old = int_i;

// Lqr_Obs(y):
//		L_out = L * (y_hat - y)
//		Sum_out = L_out + B * u + A_out
//		x_hat = Sum_out + Sum_out_old
//		A_out = x_hat * A
//		K_out = x_hat * K
//		y_hat = x_hat * C

//		Sum_out_old = Sum_out

//		return K_out

#include <iostream>
#include <math.h>
#include <string>
#include <Eigen/Dense>

#include "Observer.h"

using namespace std;
using namespace Eigen;

double speed(double x, double y, double t);

double derive(double y, double y0, double x, double x0);

double Lqr_Obs(double y, double t);

double x_old = 0.0;
double y_old = 0.0;
double t_old = 0.0;

double y_hat = 0.0;
double u = 0.0;

VectorXd A_out(2);
VectorXd x_hat_old(2);

double reference = 1.0;
const double Ki = 0.4591;

MatrixXd A(2, 2);
MatrixXd B(2, 1);
MatrixXd C(1, 2);

MatrixXd L(2, 1);
MatrixXd K(1, 2);

Observer obs;


//class SpeedController()
//{
//	SpeedController()
//	{
//
//	}
//}


// This should be in the callback function
int main()
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

	double y = 0.0;
	double int_i = 0.0;
	double int_i_old = 0.0;

	double x_pos, y_pos, time;

	for (double i = 0.0; i < 10.0; i += 0.1)
	{
		cout << "\n\nWrite y position and time...\n\n";
		cin >> y_pos >> time;

		y = speed(0.0, y_pos, time);

		int_i = (reference - y) * (time - t_old) + int_i_old;
		u = Lqr_Obs(y, time) + int_i * Ki;

		if (u > 5)
		{
			u = 5;
		}
		else if (u < 0)
		{
			u = 0;
		}

		int_i_old = int_i;
		t_old = time;

		//cout << y << "\t";

		//publish(u)
	}

	cout << "\n\nSkriv noe og trykk ENTER for \x86 avslutte...\n\n";
	string dummy = "";
	cin >> dummy;

	return 0;
}

double Lqr_Obs(double y, double t)
{
	VectorXd L_out(2);
	VectorXd Sum_out(2);
	VectorXd x_hat(2);

	L_out = L * -(y_hat - y);
	Sum_out = L_out + B * u + A_out;
	x_hat = Sum_out * (t - t_old) + x_hat_old;
	A_out = A * x_hat;

	cout << "y_hat: " << y_hat << endl;

	x_hat_old = x_hat;

	// Because the result is a 1x1 matrix, it cant be convertet directly to a double
	// The matrix in itself is an array, so the desired value can be extracted by 
	// indexing the value from the array. 
	y_hat = (C * x_hat)(0);

	return (K * x_hat)(0);
}

double derive(double y, double y0, double x, double x0)
{
	if (x == x0)
	{
		return 0.0;
	}
	else
	{
		return (y - y0) / (x - x0);
	}
}

double speed(double x, double y, double t)
{
	double speed_x = derive(x, x_old, t, t_old);

	double speed_y = derive(y, y_old, t, t_old);

	x_old = x;
	y_old = y;

	return sqrt(pow(speed_x, 2.0) + pow(speed_y, 2.0));
}