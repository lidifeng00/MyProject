package Virus;

import java.util.Random;
public class Gauss {
	static Random r = new Random();
	public static double Gaussian(double sigma, double u) {
		return r.nextGaussian() * sigma + u;
	}
	
}
