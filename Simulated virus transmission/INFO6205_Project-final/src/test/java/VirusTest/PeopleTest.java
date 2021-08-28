package VirusTest;

import Virus.People;

import static org.junit.Assert.*;
import org.junit.Test;

public class PeopleTest {
	
	@Test
	public void testMove1() {
		People p = new People(0, 200, 100, 3, 14, 0, 0.05);
		p.move();
		assertTrue(p.getX() >= 200);
		assertTrue(p.getY() >= 100);
	}
	
	@Test
	public void testMove2() {
		People p = new People(0, 1000, 900, 3, 14, 0, 0.05);
		p.move();
		assertTrue(p.getX() <= 1000);
		assertTrue(p.getY() <= 900);
	}
	
	@Test
	public void testMove3() {
		People p = new People(0, 500, 500, 3, 14, 0, 0.05);
		p.setDead();
		p.move();
		assertTrue(p.getX() == 500);
		assertTrue(p.getY() == 500);
	}
	
	@Test
	public void testInfect() {
		People p1 = new People(0, 500, 500, 3, 14, 1, 0);
		People p2 = new People(1, 500, 500, 3, 14, 0, 0);
		People p3 = new People(2, 500, 500, 3, 14, 0, 1);
		p1.setInfectProbability(1);
		p1.setK(1);
		p1.simulateInfect(p2);
		assertTrue(p2.getIsInfect() == 1);
		
		p2.setInfectProbability(1);
		p2.setK(1);
		p3.setMaskDefence(0);
		p2.simulateInfect(p3);
		assertTrue(p3.getIsInfect() == 0);
	}
	
}
