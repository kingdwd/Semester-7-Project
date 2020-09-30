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

using namespace std;
using namespace Eigen;

double speed(double x, double y, double t);

double derive(double y, double y0, double x, double x0);

double Lqr_Obs(double y);

double x_old = 0;
double y_old = 0;
double t_old = 0;

double y_hat = 0;
double u = 0;
double int_i_old = 0;

VectorXd A_out(2);
VectorXd Sum_out_old(2);

double reference = 1;
const double Ki = 0.4591;

MatrixXd A(2, 2);
MatrixXd B(2, 1);
MatrixXd C(1, 2);

MatrixXd L(2, 1);
MatrixXd K(1, 2);

// This should be in the callback function
int main()
{
	// A(0, 0) = 0.8859;
	// A(0, 1) = -0.1282;
	// A(1, 0) = 0.0943;
	// A(1, 1) = 0.9935;
	// 
	A << 0.8859, -0.1282,
		0.0943, 0.9935;

	// B(0, 0) = 0.0943;
	// B(1, 0) = 0.0048;
	// 
	B << 0.0943,
		0.0048;

	// C(0, 0) = 0.0;
	// C(0, 1) = 1.5069;
	// 
	C << 0.0,
		1.5069;

	// L(0, 0) = -7.12;
	// L(1, 0) = 1.2472;
	// 
	L << -7.12,
		1.2472;

	// K(0, 0) = -0.6397;
	// K(0, 1) = -0.7573;
	K << -0.6397, -7573;

	// =============================================

	A_out(0) = 0.0;
	A_out(1) = 0.0;

	Sum_out_old(0) = 0.0;
	Sum_out_old(1) = 0.0;

	// double s = 0.0;

	double y = 0.0;
	double int_i = 0.0;

	int teller = 0;
	int vei = 1;

	for (double i = 0.0; i < 10.0; i += 0.1)
	{
		// s = speed(0, i, i);
		// cout << s << "\t";

		if (teller % 4 == 0)
		{
			vei = 2;
		}
		else
		{
			vei = -1;
		}

		teller++;

		y = speed(0, i + 0.01*vei, i);

		int_i = (reference - y) + int_i_old;
		u = Lqr_Obs(y) + int_i * Ki;

		int_i_old = int_i;

		if (u > 3)
		{
			u = 3;
		}
		
		cout << y << "\t";

		//publish(u)
	}
	
	cout << "\n\nSkriv noe og trykk ENTER for \x86 avslutte...\n\n";
	string dummy = "";
	cin >> dummy;

	return 0;
}

double Lqr_Obs(double y)
{
	VectorXd L_out(2);
	VectorXd Sum_out(2);
	VectorXd x_hat(2);

	L_out = L * (y_hat - y);
	Sum_out = L_out + B * u + A_out;
	x_hat = Sum_out + Sum_out_old;
	A_out = A * x_hat;

	// Because the result is a 1x1 matrix, it cant be convertet directly to a double
	// The matrix in itself is an array, so the desired value can be extracted by 
	// indexing the value from the array. 
	double K_out = (K * x_hat)(0);
	double y_hat = (C * x_hat)(0);

	Sum_out_old = Sum_out;

	return K_out;
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
	t_old = t;

	return sqrt(pow(speed_x, 2.0) + pow(speed_y, 2.0));
}