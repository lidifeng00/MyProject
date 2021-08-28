package Virus;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

public class Hospital {
	
	int maxCapacity;   //define max capacity 
	public Set<People> set;
	
	private static Hospital hospital = new Hospital(200);   
	
	public static Hospital getHospital() {
		return hospital;
	}
	
	public Hospital(int maxCapacity) {
		this.maxCapacity=maxCapacity;
		set=new HashSet<People>();
	}
	
	public void add(People p) {      //put infect people into hospital 
		if(set.size()<maxCapacity) {
			if(!set.contains(p)&&p.dead==0) {
				set.add(p);
				p.setIsQurantine(1);
				p.recoverDay=(int)(p.recoverDay*0.5);      //Faster recovery in hospital
			}
		}
	}
	public void heal() {  // Rehabilitation of patients
		List<People> removeList=new ArrayList<People>();
		for(Iterator<People> it=set.iterator(); it.hasNext();) {
			People p=it.next();
			if(p.hasVaccine==1||p.dead==1) {    //Recovered or removed from the hospital.
				removeList.add(p);
			}
		}
		for(People p:removeList) {   //After removing the patient, add an isolated bed
			set.remove(p);
			p.isQurantine=0;
		}
	}
}
