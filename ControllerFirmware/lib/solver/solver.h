//
// Created by Nikilesh Ramesh on 02/08/2023.
//

#ifndef AIRBRAKES_SOLVER_H
#define AIRBRAKES_SOLVER_H

#include "vector"

class solver {
public:
    solver();
    ~solver();
    void solve();
private:
    void AdamsBashforth(double init, float timeStep, double * solution);
    void csvBuilder(double solution[], float time[], int size);
};
#endif //AIRBRAKES_SOLVER_H
