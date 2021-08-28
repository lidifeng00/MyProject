package Virus;

import java.util.Random;

public class People {
	private int id;
	private int x;
	private int y;
	double XU;
	double YU;
	double targetX;
	double targetY;

	int InfactNumber;    // each people can infect the Max population
	double k=0.3;   //the value of k
	int dead=0;   // define the death, dead is 1, alive is 0
	int incubationPeriod;  //define the time of 
	int incubationCountDown=0;   // Define the time count from the incubation period to the sick period of an infected person
	int isInfect=0;    //  Determine whether it is infected, 0 is not infected, 1 is infected
	int isWareFaceMask=0;      // Judge whether or not to wear a mask, 0 is not wearing, 1 is wearing a mask
//	double infectProbability=0.03;      //infection rate for Covid-19
	double infectProbability=0.02;     //infection rate for SARS
	double MaskDefence=0.1;     //Mask defense rate
	int isQurantine=0;   //Define whether the patient is hospitalized
	int hasVaccine=0;   //Define whether the patient has recovered
	int recoverDay=0;   //Define the number of days from illness to recovery
	int deadBaseDay;     //Define the days from illness to death
        double isTest=0.6;   //Define the prevalence of testing
	
	
	Random r = new Random();
	
	public void recover() {     //Rehabilitation function, set infection to 0, rehabilitation to 1
		isInfect=0;
		hasVaccine=1;	
	}
	
	public People(int id,int x, int y, int InfactNumber, int incubationPeriod, int isInfect,
			double wareFaceRate) {
		super();
		this.id=id;
		this.x = x;
		this.y = y;
		this.InfactNumber = InfactNumber;
		this.incubationPeriod = r.nextInt(incubationPeriod);
		this.isInfect = isInfect;
		if(r.nextDouble()<wareFaceRate) {     //The random value is less than the mask rate, and the person is wearing a mask
			this.isWareFaceMask =1;
		}
		XU = x;  //Initial location
		YU = y;
	}
	
    public int getX() {
        return x;
    }

    public void setX(int x) {
        this.x = x;
    }
    
    public void setK(double k) {
    	this.k = k;
    }
    
    public void setMaskDefence(int MaskDefence) {
    	this.MaskDefence = MaskDefence;
    }
    public void setHasVaccine(int hasVaccine) {
    	this.hasVaccine = hasVaccine;
    }

    public int getIsQurantine() {
		return isQurantine;
	}

	public void setIsQurantine(int isQurantine) {
		this.isQurantine = isQurantine;
	}

	public int getY() {
        return y;
    }

    public void setY(int y) {
        this.y = y;
    }
    
    public void setInfect() {     //Infection function
    	isInfect=1;      
    	incubationCountDown=incubationPeriod;     //Counting from infection to illness
    	recoverDay=r.nextInt(20)+7;   //Random rehabilitation days
    	deadBaseDay=recoverDay;
    }
    
    public void setDead()  //dead function
    {
    	dead=1;
    }
    
    public void nextDay() {    //Next day's judgment function
    	    	
    	if(dead==0) {    // alive
    		if(incubationCountDown>0) {   //Days of infection greater than 0 can be defined as in the incubation period
        		incubationCountDown--;    		
        	}else {
        		if(isInfect==1) {      
            		if(recoverDay==0) {     //Days to recover.
            			recover();
            		}else {
            			recoverDay--;    //reduce the recoverday if the patient is still ill
            		}
        		}
        	}
        	
        	if(isInfect==1) {    
        		if(incubationCountDown==0) {            //Become sick.
            		double random=r.nextDouble();
            		if(isQurantine==1) {                 //The patient is in hospital.
            			if(random<(0.05/deadBaseDay)) {        // The average daily mortality in the hospital, if less than this number, is death.
            				dead=1;
            			}
            		}else {
            			if(random<(0.125/deadBaseDay)) {      //The mortality rate is higher when not in hospital
            				dead=1;
            			}
           		}
//            			if(random<(0.01/deadBaseDay)) {      // death for Covid-19 
//            				dead=1;
//            			}
//            		}else {
//            			if(random<(0.025/deadBaseDay)) {
 //           				dead=1;
 //           			}
 //           		}
        		}
        	}
    	}
    	
    	
    }
    


	public void simulateInfect(People p) {
    	if(dead==0) {   //alive
    		if(isInfect==1) {       //be ill
    			if(incubationCountDown>0||isQurantine==0) {     //People who are in the incubation period or in the sick period but not in the hospital
    				if(p.isInfect==0) {    //People who don't get sick can get infected
    					if(Math.random()<=k) {  
        					if(InfactNumber>0) {  //This person can  still infect other people
                            	double distance=getDistance(p);
                            	double random=r.nextDouble();
                            	double value=infectProbability*Math.pow(0.9,distance)*(p.isWareFaceMask==1 ? p.MaskDefence : 1);  //Possibility of infection * 0.9 ^ distance * maskdefence
                            	if(random<=value&& p.dead==0&& p.hasVaccine==0) { 
                            		p.setInfect();
                            		InfactNumber--;
                            	}
                        	}
        				}
    				}	
        		}
    		}
    	}
    }

    public int isTest() {         //Whether to be tested
		return r.nextDouble()< isTest ? 1 : 0;
	}
    
    public double getDistance(People p) {  //distance
    	double distance=Math.sqrt(Math.pow(p.getX()-getX(),2)+Math.pow(p.getY()-getY(),2));
    	return distance;
    }
    
    
    
    public int getInfactNumber() {
		return InfactNumber;
	}

	public void setInfactNumber(int InfactNumber) {
		this.InfactNumber = InfactNumber;
	}

	public int getDead() {
		return dead;
	}

	public void setDead(int dead) {
		this.dead = dead;
	}
	

	public double getInfectProbability() {
		return infectProbability;
	}

	public void setInfectProbability(double infectProbability) {
		this.infectProbability = infectProbability;
	}

	public int getIncubationPeriod() {
		return incubationPeriod;
	}

	public void setIncubationPeriod(int incubationPeriod) {
		this.incubationPeriod = incubationPeriod;
	}

	public int getIncubationCountDown() {
		return incubationCountDown;
	}

	public void setIncubationCountDown(int incubationCountDown) {
		this.incubationCountDown = incubationCountDown;
	}

	public int getIsInfect() {
		return isInfect;
	}

	public void setIsInfect(int isInfect) {
		this.isInfect = isInfect;
	}

	public int getIsWareFaceMask() {
		return isWareFaceMask;
	}

	public void setIsWareFaceMask(int isWareFaceMask) {
		this.isWareFaceMask = isWareFaceMask;
	}

	public void move() {
		if(getDead()==0) {
				targetX = Gauss.Gaussian(10, XU);
		    	targetY = Gauss.Gaussian(10, YU);
		    	while(targetX < 200 || targetX > 1000)
		    		targetX = Gauss.Gaussian(10, XU);
		    	while(targetY < 100 || targetY > 900)
		    		targetY = Gauss.Gaussian(10, YU);
		    	this.x = (int) Math.round(targetX);
		    	this.y = (int) Math.round(targetY);
			}
		}
}