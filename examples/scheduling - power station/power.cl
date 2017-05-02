
void generate_powers_type1(int* quarters, int value, int power) {
  // for type 1 power station, it uses 2 quarters for maintainence.
  // no power generates if it is at quarter 1, 2 or quarter 4, 1
  quarters[0] += (value == 3 || value == 0 ? 0 : power);
  // no power generates if it is at quarter 1, 2 or quarter 2, 3
  quarters[1] += (value == 0 || value == 1 ? 0 : power);
  // no power generates if it is at quarter 2, 3 or quarter 3, 4
  quarters[2] += (value == 1 || value == 2 ? 0 : power);
  // no power generates if it is at quarter 3, 4 or quarter 4, 1
  quarters[3] += (value == 2 || value == 3 ? 0 : power);
}

void generate_powers_type2(int* quarters, int value, int power) {
  // for type 2 power station, it uses 1 quarters for maintainence.
  // no power generates if it is at quarter 1
  quarters[0] += (value == 0 ? 0 : power);
  // no power generates if it is at quarter 2
  quarters[1] += (value == 1 ? 0 : power);
  // no power generates if it is at quarter 3
  quarters[2] += (value == 2 ? 0 : power);
  // no power generates if it is at quarter 4
  quarters[3] += (value == 3 ? 0 : power);
}

void power_station_fitness(global __SimpleChromosome* chromosome,
                           global float* fitnesses,
                           int chromosome_size,
                           int chromosome_count)
{

  // Assume that we have two types power generators:
  // Type 1: this type needs two quarters for maintainence.
  // Type 2: this type needs 1 quarter for maintainence.
  // We have 2 type 1 generators and 5 type 2 generates. In a year, we need to
  // schedule a maintainence plan. With this plan, the power consumptions of
  // each quarters have to be satisfied, that is 89, 90, 65, 70. The question is
  // what plan you will choose..

  // The power generated by all units.
  int CAPACITIES[] = {20, 15, 34, 50, 15, 15, 10};
  // The maximum load of each quarter
  int LOADS[] = {-80, -90, -65, -70};
  // calculate the power generation by unit 1 ~ 7 at each quarters.
  generate_powers_type1(LOADS, chromosome->genes[0], CAPACITIES[0]);
  generate_powers_type1(LOADS, chromosome->genes[1], CAPACITIES[1]);
  generate_powers_type2(LOADS, chromosome->genes[2], CAPACITIES[2]);
  generate_powers_type2(LOADS, chromosome->genes[3], CAPACITIES[3]);
  generate_powers_type2(LOADS, chromosome->genes[4], CAPACITIES[4]);
  generate_powers_type2(LOADS, chromosome->genes[5], CAPACITIES[5]);
  generate_powers_type2(LOADS, chromosome->genes[6], CAPACITIES[6]);
  // let
  *fitnesses = LOADS[0] < LOADS[1] ? LOADS[0] : LOADS[1];

  if (LOADS[2] < LOADS[3] && LOADS[2] < *fitnesses) {
    *fitnesses = LOADS[2];
  } else if (LOADS[3] < *fitnesses) {
    *fitnesses = LOADS[3];
  }

  if (*fitnesses < 0) {
    *fitnesses = 0;
  }
}
