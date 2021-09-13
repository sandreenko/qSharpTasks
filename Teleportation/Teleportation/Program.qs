namespace Quantum.Teleportation {

    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;

    operation Entangle (qAlice : Qubit, qBob : Qubit) : Unit {
        H(qAlice);
        CNOT(qAlice, qBob);
    }

    operation SendMessage (qAlice : Qubit, qMessage : Qubit) : (Bool, Bool) {
        CNOT(qMessage, qAlice);
        H(qMessage);
        mutable messageResult = false;
        if (M(qMessage) == One)
        {
            set messageResult = true;
        }
        mutable quibitResult = false;
        if (M(qAlice) == One)
        {
            set quibitResult = true;
        }
        return (messageResult, quibitResult);
    }

    operation ReconstructMessage(qBob : Qubit, (b1 : Bool, b2 : Bool)) : Unit {
        if (b1 == true)
        {
            Z(qBob);
        }
        if (b2 == true)
        {
            X(qBob);
        }
    }
    
    operation StandardTeleport (qAlice : Qubit, qBob : Qubit, qMessage : Qubit) : Unit {
        Entangle(qAlice, qBob);
        let (b1, b2) = SendMessage(qAlice, qMessage);
        ReconstructMessage(qBob, (b1, b2));
    }

    operation PrepareAndSendMessage (qAlice : Qubit, basis : Pauli, state : Bool) : (Bool, Bool) {
        use qM = Qubit();
        if (basis == PauliX)
        {
            Ry(PI() * 3.0 / 2.0, qM);
        }
        elif (basis == PauliY)
        {
            Rx(PI() * 3.0 / 2.0, qM);
        }
        if (state == true)
        {
            X(qM);
        }

        return SendMessage(qAlice, qM);
    }

    operation ReconstructAndMeasureMessage (qBob : Qubit, (b1 : Bool, b2 : Bool), basis : Pauli) : Bool {
        
        ReconstructMessage(qBob, (b1, b2));
        if (basis == PauliX)
        {
            Ry(-PI() * 3.0 / 2.0, qBob);
        }
        elif (basis == PauliY)
        {
            Rx(-PI() * 3.0 / 2.0, qBob);
        }
        if (M(qBob) == One)
        {
            return true;
        }
        return false;
    }

    @EntryPoint()
    operation TP () : Unit {
        use qBob = Qubit();
        use qAlice = Qubit();
        use message = Qubit();

        X(message);
        StandardTeleport(qAlice, qBob, message);
        if (M(qBob) == One)
        {
            Message("The message was delivered!");
        }
        else
        {
            Message("The pigeon was shoot half-way!");
        }
    }
}
