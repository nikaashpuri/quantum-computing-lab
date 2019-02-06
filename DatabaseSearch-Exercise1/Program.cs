// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.


using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Microsoft.Quantum.Samples.DatabaseSearch
{
    class Program
    {
        public static void Pause()
        {
            System.Console.WriteLine("Press any key to continue...\n");
            System.Console.ReadKey();
        }

        static void Main(string[] args)
        {

            #region Setup

            // We begin by defining a quantum simulator to be our target
            // machine.
            var sim = new QuantumSimulator(throwOnReleasingQubitsNotInZeroState: true);

            #endregion

            #region Quantum Database Search with Manual Oracle Definitions

            // Let us investigate the success probability of the quantum search.
            
            // Wedefine the size `N` = 2^n of the database to searched in terms of 
            // number of qubits `n`. 
            var nDatabaseQubits = 6;
            var databaseSize = Math.Pow(2.0, nDatabaseQubits);

            // We now perform Grover iterates to amplify the marked subspace.
            var nIterations = 3;

            // Number of queries to database oracle.
            var queries = nIterations * 2 + 1;

            // We now execute the quantum search and verify that the success 
            // probability matches the theoretical prediction. 
            var classicalSuccessProbability = 1.0 / databaseSize;
            var quantumSuccessProbability = Math.Pow(Math.Sin((2.0 * (double)nIterations + 1.0) * Math.Asin(1.0 / Math.Sqrt(databaseSize))),2.0);
            var repeats = 100;
            var numberSuccess = 0;
            var numberTotal = 0;

            foreach (var idxAttempt in Enumerable.Range(0, repeats))
            {

                // Each operation has a static method called Run which takes a simulator as
                // an argument, along with all the arguments defined by the operation itself.  
                var task = ApplyQuantumSearch.Run(sim, nIterations, nDatabaseQubits);

                // We extract the return value of the operation by getting the Results property.
                var data = task.Result;

                // Extract the marked qubit state
                var markedQubit = data.Item1;
                var databaseRegister = data.Item2.ToArray();
                var isSuccess = true;

                foreach (var elt in databaseRegister) {
                    if (elt.ToString() == "Zero") {
                        isSuccess = false;
                    }
                }

                if (isSuccess) {
                    numberSuccess += 1;
                }

                Console.Write("Output of Grover's search in binary\n");
                Console.Write(string.Join(", ", databaseRegister) + "\n");

                numberTotal += 1;

                Console.WriteLine("Statistics so far...");
                Console.WriteLine($"Total number of attempts = {numberTotal}");
                Console.WriteLine($"Total number of successes = {numberSuccess}");

                Pause();
            }

            // Pause();

            #endregion

        }
    }
}
