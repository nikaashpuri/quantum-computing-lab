// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

// important points 
// 

namespace Microsoft.Quantum.Samples.DatabaseSearch {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Canon;
    
    
    operation DatabaseOracle (markedQubit : Qubit, databaseRegister : Qubit[]) : Unit {
        
        body (...) {
            // The Controlled functor applies its operation conditioned on the
            // first input being in the |11…1〉 state, which is precisely
            // what we need for this example.

            Controlled X(databaseRegister, markedQubit);
        }
        
        adjoint invert;
    }

    operation DatabaseOracle2 (markedQubit : Qubit, databaseRegister : Qubit[]) : Unit {
        
        body (...) {
            // if the first qubit is a 1
            // it counts as a solution state
            Controlled X(databaseRegister[0], markedQubit);
        }
        
        adjoint invert;
    }
    
    
    operation UniformSuperpositionOracle (databaseRegister : Qubit[]) : Unit {
        
        body (...) {
            let nQubits = Length(databaseRegister);
            
            for (idxQubit in 0 .. nQubits - 1) {
                // apply the Hadamard gate 
                H(databaseRegister[idxQubit]);
            }
        }
        
        adjoint invert;
    }
    
    /// # Summary
    /// Reflection about the |00…0〉 state.
    /// If input is |00…0〉, return -|00…0〉, else return the input state unchanged
    ///
    /// # Input
    /// ## databaseRegister
    /// A register of n qubits initially in the |00…0〉 state.
    operation ReflectZero (databaseRegister : Qubit[]) : Unit {
        
        let nQubits = Length(databaseRegister);
        
        // this ensures that |000...000> becomes |111...111>
        for (idxQubit in 0 .. nQubits - 1) {
            X(databaseRegister[idxQubit]);
        }
        
        // a Z gate makes a |1> into a -|1>
        Controlled Z(databaseRegister[1 .. nQubits - 1], databaseRegister[0]);
        
        // return to the original state
        for (idxQubit in 0 .. nQubits - 1) {
            X(databaseRegister[idxQubit]);
        }
    }
    
    operation ReflectAroundAverage (databaseRegister : Qubit[]) : Unit {
        
        // to reflect around average, we need 3 steps
        // 1. apply Hadamard gates to all qubits
        Adjoint UniformSuperpositionOracle(databaseRegister);
        // 2. Reflect the all zero state
        ReflectZero(databaseRegister);
        // 3. apply Hadamard gates to all qubits
        UniformSuperpositionOracle(databaseRegister);
    }
    
    
    operation QuantumSearch (nIterations : Int, markedQubit : Qubit, databaseRegister : Qubit[]) : Unit {
        
        // coding exercise 1 
        // you need to send the input qubit register into 
        // an equal superposition of all possible states
        // TODO - call the correct operator
        UniformSuperpositionOracle(databaseRegister);
        
        // these are important
        X(markedQubit);
        H(markedQubit);

        // Loop over Grover iterations
        for (idx in 0 .. nIterations - 1) {
            // coding exercise 1 
            // you need to implement the Grover iterations
            // remember that each iteration consists of two key steps
            // 1. apply the database oracle to flip the amplitude of the solution state
            // TODO - call the correct operator
            DatabaseOracle(markedQubit, databaseRegister);
            // 2. apply the inversion around average step 
            ReflectAroundAverage(databaseRegister);
        }
    }
    
    
    // Let us now create an operation that allocates qubits for Grover's
    // algorithm, implements the `QuantumSearch`, measures the marked qubit
    // the database register, and returns the measurement results.
    
    
    operation ApplyQuantumSearch (nIterations : Int, nDatabaseQubits : Int) : (Result, Result[]) {
        
        // Allocate variables to store measurement results.
        mutable resultSuccess = Zero;
        mutable resultElement = new Result[nDatabaseQubits];
        
        // Allocate nDatabaseQubits + 1 qubits. These are all in the |0〉
        // state.
        using (qubits = Qubit[nDatabaseQubits + 1]) {
            
            // Define marked qubit to be indexed by 0.
            let markedQubit = qubits[0];
            
            // Let all other qubits be the database register.
            let databaseRegister = qubits[1 .. nDatabaseQubits];
            
            // Implement the quantum search algorithm.
            QuantumSearch(nIterations, markedQubit, databaseRegister);
            
            // Measure the marked qubit. On success, this should be One.
            set resultSuccess = M(markedQubit);
            
            // Measure the state of the database register post-selected on
            // the state of the marked qubit.
            set resultElement = MultiM(databaseRegister);
            
            // These reset all qubits to the |0〉 state, which is required
            // before deallocation.
            if (resultSuccess == One) {
                X(markedQubit);
            }
            
            for (idxResult in 0 .. nDatabaseQubits - 1) {
                
                if (resultElement[idxResult] == One) {
                    X(databaseRegister[idxResult]);
                }
            }
        }
        
        // Returns the measurement results of the algorithm.
        return (resultSuccess, resultElement);
    }
    
}


