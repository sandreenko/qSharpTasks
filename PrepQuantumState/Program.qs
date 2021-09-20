namespace Quantum.PrepQuantumState {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;

    /// # Summary
    /// Prepare a qubit in a zero state to be in probs[0]|0> + probs[1]|1> state.
    ///
    /// # Input
    /// ## q
    /// The qubit in zero state in PailiZ basic.
    /// ## probs
    /// The two elements array with probabilities values.
    ///
    operation PrepareSingleQubitState (q : Qubit, probs : Double[]) : Unit {
        AssertAllZero([q]);
        Fact(Length(probs) == 2, "the array of probabilities has wrong length");
        Fact(probs[0] * probs[0] + probs[1] * probs[1] == 1.0, "the probabilities are wrong");
        let theta = ArcTan2(probs[1], probs[0]);
        Ry(theta * 2.0, q);
    }
    

    @EntryPoint()
    operation HelloQ () : Unit {
        use q = Qubit();
        PrepareSingleQubitState(q, [1.0, 0.0]);
        AssertAllZero([q]);
        PrepareSingleQubitState(q, [0.0, 1.0]);
        AssertQubit(One, q);
        Reset(q);

        let p1 = 1.0/Sqrt(2.0);

        PrepareSingleQubitState(q, [p1, Sqrt(1.0 - p1*p1)]);
        let c = Complex(p1, 0.0);
        AssertQubitIsInStateWithinTolerance((c, c), q, 0.0001);
        Reset(q);

    }
}
