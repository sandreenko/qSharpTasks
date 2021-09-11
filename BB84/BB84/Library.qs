namespace Quantum.BB84 {

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
	      } 
          else
          {
              set arr w/= index <- false;
          }          
	  }
      Message($"The random array is {arr}");
      return arr;
    }

    operation PrepareAlicesQubits (qs : Qubit[], bases : Bool[], bits : Bool[]) : Unit {
        let N = Length(qs);
        for index in 0 .. N - 1 {
            if (bases[index] == true)
            {
                DiagonalBasis(qs[index]);
            }
            if (bits[index] == true)
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
        Message($"Bob measured: {arr}");
        return arr;
    }

    function GenerateSharedKey (basesAlice : Bool[], basesBob : Bool[], measurementsBob : Bool[]) : Bool[] {
        let N = Length(basesAlice);
        
        mutable matching = 0;
        for index in 0 .. N - 1 {
            if (basesAlice[index] == basesBob[index])
            {
                set matching = matching + 1;
            }
		}
        mutable arr = new Bool[matching];
        mutable j = 0;
        for index in 0 .. N - 1 {
            if (basesAlice[index] == basesBob[index])
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
        if (wrong * 100 <= errorRate * N)
        {
            return true;
        }
        return false;
    } 

     operation Run_BB84Protocol () : Unit {
        let N = 100;
        let errorRate = 10;
        use qs = Qubit[N];
        mutable basesAlice = RandomArray(N);
        mutable bitsAlice = RandomArray(N);
        PrepareAlicesQubits(qs, basesAlice, bitsAlice);

        mutable basesBob = RandomArray(N);
        let bitsBob = MeasureBobsQubits(qs, basesBob);
        mutable keyBob = GenerateSharedKey(basesAlice, basesBob, bitsBob);
        mutable keyAlice = GenerateSharedKey(basesAlice, basesBob, bitsAlice);
        if (CheckKeysMatch(keyBob, keyAlice, errorRate))
        {
            Message("Error rate is too high, eavesdropping?");
        }
        Message($"The generated key is {keyBob}");
    }

}
