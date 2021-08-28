package VirusTest;

import Virus.Hospital;
import Virus.People;

import static org.junit.Assert.*;
import org.junit.Test;

public class HospitalTest {

	@Test
	public void testHeal() {
		Hospital h = new Hospital(200);
		for(int i = 0; i < 10; i++) {
			People p = new People(0, 500, 500, 3, 14, 0, 0.05);
			p.setHasVaccine(1);
			h.add(p);
		}
		for(int i = 0; i < 10; i++) {
			People p = new People(0, 500, 500, 3, 14, 0, 0.05);
			p.setDead();
			h.add(p);
		}
		for(int i = 0; i < 10; i++) {
			People p = new People(0, 500, 500, 3, 14, 0, 0.05);
			h.add(p);
		}
		assertTrue(h.set.size() == 20);
		h.heal();
		assertTrue(h.set.size() == 10);
	}
}
