namespace Quantum.Mannin_BB84_1 {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    operation EqualSuperposition (q : Qubit) : Unit {
		H(q);
    }

    operation DiagonalBasis(q : Qubit) : Unit {
		H(q);
    }

    operation RandomArray (N : Int) : Bool[] {
      mutable arr = new Bool[N];
      use q = Qubit();
      for index in 0 .. N - 1 {
          EqualSuperposition(q);
          let r = M(q);
          if (M(q) == One)
          {
                set arr w/= index <- true;
                X(q);
	      } 
          else
          {
              set arr w/= index <- false;
          }          
	  }
      return arr;
    }

    operation PrepareAlicesQubits (qs : Qubit[], bases : Bool[], bits : Bool[]) : Unit {
        let N = Length(qs);
        for index in 0 .. N - 1 {
            if (bases[index] == true)
            {
                DiagonalBasis(qs[index]);
                if (bits[index] == true)
                {
                    Z(qs[index]);
                }
            }
            elif (bits[index] == true)
            {
                X(qs[index]);
            }

		}
    }

    operation MeasureBobsQubits (qs : Qubit[], bases : Bool[]) : Bool[] {
        let N = Length(qs);
        mutable arr = new Bool[N];
        for index in 0 .. N - 1 {
            if (bases[index] == true)
            {
                DiagonalBasis(qs[index]);
            }
            if (M(qs[index]) == One)
            {
                set arr w/= index <- true;
	        } 
            else
            {
                set arr w/= index <- false;
            }    
		}
        return arr;
    }

    function GenerateSharedKey (basisAlice : Bool[], basisBob : Bool[], measurementsBob : Bool[]) : Bool[] {
        let N = Length(basisAlice);
        
        mutable matching = 0;
        for index in 0 .. N - 1 {
            if (basisAlice[index] == basisBob[index])
            {
                set matching = matching + 1;
            }
		}
        mutable arr = new Bool[matching];
        mutable j = 0;
        for index in 0 .. N - 1 {
            if (basisAlice[index] == basisBob[index])
            {
                set arr w/= j <- measurementsBob[index];
                set j = j + 1;
            }
		}
        return arr;
    }

    function CheckKeysMatch (keyAlice : Bool[], keyBob : Bool[], errorRate : Int) : Bool {
        let N = Length(keyAlice);
        mutable wrong = 0;
        for index in 0 .. N - 1 {
            if (keyAlice[index] != keyBob[index])
            {
                set wrong = wrong + 1;
            }
		}
        Message($"There are {wrong} wrong bits out of {N}");
        if (wrong * 100 <= errorRate * N)
        {
            return true;
        }
        return false;
    } 

    @EntryPoint()
    operation Run_BB84Protocol () : Unit {
        let N = 10;
        let errorRate = 10;
        
        mutable basisAlice = RandomArray(N);
        Message($"Alice's basis array: {basisAlice}");

        mutable bitsAlice = RandomArray(N);
        Message($"Alice's bits array: {bitsAlice}");
        use qs = Qubit[N];
        PrepareAlicesQubits(qs, basisAlice, bitsAlice);

        mutable basisBob = RandomArray(N);
        Message($"Bob's basis array: {basisBob}");
        let bitsBob = MeasureBobsQubits(qs, basisBob);
        Message($"Bob's bits array: {bitsBob}");

        mutable keyAlice = GenerateSharedKey(basisAlice, basisBob, bitsAlice);
        mutable keyBob = GenerateSharedKey(basisAlice, basisBob, bitsBob);
        Message($"Alice's key: {keyAlice}");
        Message($"Bob's key: {keyBob}");

        if (CheckKeysMatch(keyBob, keyAlice, errorRate) == false)
        {
            Message("Error rate is too high, eavesdropping?");
        }
        Message($"The generated key is {keyBob}");

    }
}
