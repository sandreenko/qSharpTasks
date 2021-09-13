using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static System.Diagnostics.Debug;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Microsoft.Quantum.BB84
{
    static class Program
    {
        static void PrintWithDots(string s)
        {
            Console.Write(s);
            for (int i = s.Length; i < 40; ++i)
            {
                Console.Write(".");
            }
        }

        static void PrintBit(bool b)
        {
            if (b == false)
            {
                Console.Write("0");
            }
            else
            {
                Console.Write("1");
            }
        }

        static void PrintBasis(bool v)
        {
            if (v == false)
            {
                Console.Write("Z");
            }
            else
            {
                Console.Write("X");
            }
        }


        static void PrintPhoton(long p)
        {
            char c = (char)0;
            switch (p)
            {
                case 0:
                    c = '0';
                    break;
                case 1:
                    c = '1';
                    break;
                case 2:
                    c = '-';
                    break;
                case 3:
                    c = '+';
                    break;
            }
            Console.Write(c);
        }

        static void PrintBasisCompare(IQArray<bool> basis, IQArray<long> indexes)
        {

        }

        static void PrintSharedBits(IQArray<bool> bits, IQArray<long> indexes)
        {

        }


        struct InfoAboutOneBit
        {
            public bool alicesBasis;
            public bool alicesBit;
            public bool bobsBasis;
            public bool bobsBit;

            public long photon;
        }

        static async Task Main(string[] args)
        {
            int N = 10;
            InfoAboutOneBit[] arr = new InfoAboutOneBit[N];

            using var sim = new QuantumSimulator();

            for (int i = 0; i < N; ++i)
            {
                InfoAboutOneBit info;
                (info.alicesBasis, info.alicesBit, info.bobsBasis, info.bobsBit) =
                    await GetOneQubitInfo.Run(sim);

                if (info.alicesBasis && info.alicesBit)
                {
                    info.photon = 3;
                }
                else if (info.alicesBasis)
                {
                    info.photon = 2;
                }
                else if (info.alicesBit)
                {
                    info.photon = 1;
                }
                else
                {
                    info.photon = 0;
                }

                arr[i] = info;
            }            

            Console.WriteLine("  Quantum Transmision");

            PrintWithDots("Alice's random bits");
            for (int i = 0; i < N; ++i)
            {
                PrintBit(arr[i].alicesBit);
            }
            Console.WriteLine();

            PrintWithDots("Alice's sending bases");
            for (int i = 0; i < N; ++i)
            {
                PrintBasis(arr[i].alicesBasis);
            }
            Console.WriteLine();


            PrintWithDots("Photons Alice sends");
            for (int i = 0; i < N; ++i)
            {
                PrintPhoton(arr[i].photon);
            }
            Console.WriteLine();


            PrintWithDots("Bob's receiving bases");
            for (int i = 0; i < N; ++i)
            {
                PrintBasis(arr[i].bobsBasis);
            }
            Console.WriteLine();


            PrintWithDots("Bob's received bits");
            for (int i = 0; i < N; ++i)
            {
                PrintBasis(arr[i].bobsBit);
            }
            Console.WriteLine();


            Console.WriteLine("  Public Discussion");

            PrintWithDots("Alice and Bob compare bases");
            for (int i = 0; i < N; ++i)
            {
                if (arr[i].alicesBasis == arr[i].bobsBasis)
                {
                    PrintBasis(arr[i].alicesBasis);
                }
                else
                {
                    Console.Write(" ");
                }
            }
            Console.WriteLine();

            string result = "";
            PrintWithDots("Shared bits");
            for (int i = 0; i < N; ++i)
            {
                if (arr[i].alicesBasis == arr[i].bobsBasis)
                {
                    PrintBasis(arr[i].alicesBit);
                    if (arr[i].alicesBit)
                    {
                        result += '1';
                    }
                    else
                    {
                        result += '0';
                    }
                }
                else
                {
                    Console.Write(" ");
                }
            }
            Console.WriteLine();
            Console.WriteLine(result);
        }
       

    }
}