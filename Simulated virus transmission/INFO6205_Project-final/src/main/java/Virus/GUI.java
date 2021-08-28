package Virus;

import javax.swing.*;

import java.util.List;

public class GUI {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Demo();
	}
	
	private static void Demo() {
		Panel p = new Panel();
		Thread thread = new Thread(p);
//		JFrame jf = new JFrame("Covid-19 Simulation");
		JFrame jf = new JFrame("SARS Simulation");
		jf.add(p);
		jf.setSize(1100,1100);
		jf.setLocationRelativeTo(null);
		jf.setVisible(true);
		jf.setDefaultCloseOperation(jf.EXIT_ON_CLOSE);
		thread.start();
	}
	
	
	
}