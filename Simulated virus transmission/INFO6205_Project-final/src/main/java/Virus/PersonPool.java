package Virus;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class PersonPool {
	
	private static PersonPool personpool = new PersonPool();
	
	public static PersonPool getPool() {
		return personpool;
	}
	
	List<People> PeopleList = new ArrayList<People>();
	
	public List<People> getList(){
		return PeopleList;
	}

	private PersonPool() {
		for(int i = 0; i < 4000; i++) {
			Random r = new Random();
			int x = (int)(100 * r.nextGaussian() + 600);
			int y = (int)(100 * r.nextGaussian() + 500);
			while(x < 200 || x > 1000)
				x = (int)(100 * r.nextGaussian() + 600);
			while(y < 100 || y > 900)
				y = (int)(100 * r.nextGaussian() + 400);
//  		    People newPeople=new People(i,x, y,10,14,0,0.05);
			People newPeople=new People(i,x, y,7,7,0,0.05);
			if(i < 5) {
				newPeople.setIsWareFaceMask(0);
				newPeople.setInfect();
			}
			PeopleList.add(newPeople);
			
		}
	}


}