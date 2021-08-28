package Virus;

import javax.swing.*;
import java.awt.*;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

public class Panel extends JPanel implements Runnable {
	private int day=0;

	private int moveTimes=0;
	private int QX;
	private int QY;

	
	public Panel() {
		this.setBackground(new Color(0x444444));

	}
	
	public void paint(Graphics g) {
		QX = 80;
		QY = 210;
		super.paint(g);
		List<People> p = PersonPool.getPool().getList();
		Hospital hospital=Hospital.getHospital();
		 int infectCount=0;
                 int TestinfectCount=0;
		 int incubationCount=0;
		 int deadCount=0;
		 int recoverPeople=0;
		 
		 g.setColor(new Color(0xFFFFFF));
		 g.drawRect(75, 205, 80, 80);
		
		moveTimes++;
		if(moveTimes%5==0) {    //Each person moves five times a day.
			day++;
			
//			System.out.println("Day: "+day);
			for(People x : p) {
					if(x.isInfect==1&&x.incubationCountDown==0) {    //If the patient is infected and sick at the same time, he will enter the hospital.
						hospital.add(x);
					}
					x.nextDay();
			}
			hospital.heal();
		}

		
		for(People x : p) {
			if(x.isInfect==1&x.dead==0) { //Number of infected people
				infectCount++;
                                if(x.isTest()==1)
					TestinfectCount++;   //Number of test infected people
				if(x.incubationCountDown>0) {   //The number of people who are infected but are in the incubation period
					incubationCount++;
				}
			}
			if(x.hasVaccine==1) recoverPeople++;
			if(x.dead==1) deadCount++;
			paintPeople(g,x); //Isolated people
			x.move();
		}
		
		for(int i=0;i<p.size();i++) {
			People people=p.get(i);
			for(int j=0;j<p.size();j++) {
				if(i!=j) {
					People targetPeople=p.get(j);
					people.simulateInfect(targetPeople);
				}

			}
		}
		g.setColor(new Color(0xFFFFFF));
		g.drawString("Day: "+day, 75, 75);
		g.setColor(new Color(0xDC143C));
		g.drawString("Test Infect People (True Infect People): "+TestinfectCount+" ("+infectCount+")", 75, 95);
		if(moveTimes%5==0) System.out.println(infectCount);
		g.setColor(new Color(0x0000FF));
		g.drawString("Incubation People: "+incubationCount, 75, 115);
		g.setColor(new Color(0xFFA500));
		g.drawString("Recover People: "+recoverPeople, 75, 175);
		g.setColor(new Color(0x000000));
		g.drawString("Dead: "+deadCount, 75, 135);
		g.setColor(new Color(0x00FF00));
		g.drawString("In Hospital(Quarantine): "+hospital.set.size(), 75, 155);
		g.setColor(new Color(0xFFFFFF));
		g.drawString("Quarantine Area", 75, 200);
		
	}
	
	public void paintPeople(Graphics g, People p) {
		g.setColor(new Color(0xdddddd));
		if(p.isInfect==1) {
			g.setColor(new Color(0xDC143C));
			if(p.incubationCountDown > 0) {
				g.setColor(new Color(0x0000FF));
			}
		}
	
		if(p.isQurantine==1) {     //put into hospital
			if(QX < 150) {
				p.setX(QX);
				QX += 5;
			}
			p.setY(QY);
			if(QX == 150) {
				QX = 80;
				QY += 5;
			}
			g.setColor(new Color(0x00FF00));
		}
		if(p.getDead()==1) {
			g.setColor(new Color(0x000000));
		}
		if(p.hasVaccine==1) {
			g.setColor(new Color(0xFFA500));
		}
		
		g.fillOval(p.getX(), p.getY(), 3, 3);
	}
	
	public Timer timer = new Timer();
	
	public void run() {
		timer.schedule(new TimerTask() {
			public void run() {
				Panel.this.repaint();
			}
		}, 0, 200);
	}	

}
