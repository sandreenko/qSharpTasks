namespace Microsoft.Quantum.BB84 {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    
    operation EqualSuperposition (q : Qubit) : Unit {
		H(q);
    }

    operation DiagonalBasis(q : Qubit) : Unit {
		H(q);
    }

    operation GetQubits(N: Int) : Qubit[] {
        use qs = Qubit[N];
        return qs;
    }


    operation RandomBool () : Bool {
        use q = Qubit();
        EqualSuperposition(q);
        let r = M(q);
        if (M(q) == One)
        {
            X(q);
            return true;
        } 
        else
        {
            return false;
        }
    }

    operation GetOneQubitInfo() : (Bool, Bool, Bool, Bool) {
        let alicesBasis = RandomBool();
        let alicesBit = RandomBool();

        use q = Qubit();
        PrepareAlicesQubits(q, alicesBasis, alicesBit);

        let bobsBasis = RandomBool();

        let bobsBit = MeasureBobsQubits(q, bobsBasis);
        return (alicesBasis, alicesBit, bobsBasis, bobsBit);

    }

    operation PrepareAlicesQubits (q : Qubit, basis : Bool, bits : Bool) : Unit {
        if (basis == true)
        {
            DiagonalBasis(q);
            if (bits == true)
            {
                Z(q);
            }
        }
        elif (bits == true)
        {
            X(q);
        }
    }

    operation MeasureBobsQubits (q : Qubit, bases : Bool) : Bool {
        if (bases == true)
        {
            DiagonalBasis(q);
        }
        if (M(q) == One)
        {
            return true;
	    } 
        else
        {
            return false;
        }    
    }
}
