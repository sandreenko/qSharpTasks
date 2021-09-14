namespace Quantum.CompresedTransfer {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    

    operation CreateEntangledPair (q1 : Qubit, q2 : Qubit) : Unit is Adj {
        H(q1);
        CNOT(q1, q2);
    }

    newtype ProtocolMessage = (Bit1 : Bool, Bit2 : Bool);

    operation EncodeMessageInQubit (qAlice : Qubit, message : ProtocolMessage) : Unit {
        if (message::Bit1 == true) { // accesses the item 'Bit1' of 'message'
            X(qAlice);
        }
        if (message::Bit2 == true) {
            Z(qAlice);
        }
    }

    operation DecodeMessageFromQubits (qAlice : Qubit, qBob : Qubit) : ProtocolMessage {
        CNOT(qAlice, qBob);
        H(qAlice);
        mutable res = ProtocolMessage(false, false);
        if (M(qAlice) == One)
        {
            set res w/= Bit2 <- true;
        }
        if (M(qBob) == One)
        {
            set res w/= Bit1 <- true;
        }
    
        return res;
    }

    operation EqualSuperposition (q : Qubit) : Unit {
		H(q);
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
    
    @EntryPoint()
    operation Superdense() : Unit {
        mutable aliceMessage = ProtocolMessage(false, false);
        set aliceMessage w/= Bit1 <- true;
        set aliceMessage w/= Bit2 <- true;
        
        use qAlice = Qubit();
        use qBob = Qubit();

        CreateEntangledPair(qAlice, qBob);
        EncodeMessageInQubit(qAlice, aliceMessage);
        let bobMessage = DecodeMessageFromQubits(qAlice, qBob);
        if (aliceMessage::Bit1 != bobMessage::Bit1) {
            Message("wrong bit1");
        }
        elif (aliceMessage::Bit2 != bobMessage::Bit2) {
            Message("wrong bit2");
        }
        else {
            Message("The message was passed");
        }
        

    }
}
