---
title: "STUDENT PAPER: An Implementation of Parallel Bayesian Network Learning"
author:
  - |
    | Joseph S. Haddad
    | The University of Akron
    | 302 E Buchtel Ave
    | Akron, OH, 44325, United States
    | jsh77@zips.uakron.edu
  - |
    | Timothy W. O'Neil
    | The University of Akron
    | 302 E Buchtel Ave
    | Akron, OH, 44325, United States
    | toneil@uakron.edu
  - |
    | Anthony Deeter
    | The University of Akron
    | 302 E Buchtel Ave
    | Akron, OH, 44325, United States
    | aed27@zips.uakron.edu
  - |
    | Zhong-Hui Duan
    | The University of Akron
    | 302 E Buchtel Ave
    | Akron, OH, 44325, United States
    | duan@uakron.edu
tags: [Parallel, Processing, OpenMP, MPI, Bayesian, CUDA, Network, Petascale]
abstract: |
  Bayesian networks may be utilized to infer genetic relations among genes. This has proven useful in providing information about how gene interactions influence life.
  However, Bayesian network learning is slow due to the nature of the algorithm. K2, a search space reduction, helps speed up the learning process but may introduce bias. To eliminate this bias, multiple Bayesian networks must be computed.
  This paper evaluates and realizes parallelization of network generation and the reasoning behind the choices made.
  Methods are developed and tested to evaluate the results of the implemented accelerations. Generating networks across multiple cores results in a linear speed-up with negligible overhead. Distributing the generation of networks across multiple machines also introduces linear speed-up, but results in additional overhead.
references:
  - id: firstpaper
    title: Analysis of Parallel Bayesian Network Learning
    container-title: "TODO: volume, issue"
    issued:
      year: 2016
    page: 101-106
    author:
      - given: Joseph S.
        family: Haddad
      - given: Anthony
        family: Deeter
      - given: Zhong-Hui
        family: Duan
      - given: Timothy W.
        family: O’Neil
    type: article-journal
  - id: cooper
    title: A Bayesian method for the induction of probabilistic networks from data
    container-title: Machine Learning
    issued:
      year: 1992
    volume: 9
    issue: 4
    page: 309-347
    author:
      - given: Gregory F.
        family: Cooper
      - given: Edward
        family: Herskovits
    type: article-journal
  - id: altekar
    title: Parallel metropolis coupled Markov chain Monte Carlo for Bayesian phylogenetic inference
    container-title: Bioinformatics
    issued:
      year: 2004
    volume: 20
    issue: 3
    page: 407-415
    type: article-journal
    author:
      - given: Gautam
        family: Altekar
      - given: Sandhya
        family: Dwarkadas
      - given: John P.
        family: Huelsenbeck
      - given: Fredrik
        family: Ronquist
  - id: misra
    title: "Parallel Bayesian network structure learning for genome-scale gene networks"
    container-title: International Conference for High Performance Computing, Networking, Storage and Analysis
    issued:
      year: 2014
    volume: SC14
    page: 461-472
    type: article-journal
    author:
      - given: Sanchit
        family: Misra
      - given: Vasimuddin
        family: Md
      - given: Kiran
        family: Pamnany
      - given: Sriram P.
        family: Chockalingam
      - given: Yong
        family: Dong
      - given: Min
        family: Xie
      - given: Maneesha R.
        family: Aluru
      - given: Srinivas
        family: Aluru
  - id: sriram
    title: Predicting Gene Relations Using Bayesian Networks
    issued:
      year: 2011
    school: Department of Computer Science, University of Akron
    author:
      - given: Aparna
        family: Sriram
    type: thesis
  - id: pearl
    type: book
    title: Probabilistic inference in intelligent systems
    issued:
      year: 1998
    publisher: Morgan Kaufmann Publishers
    author:
      - given: Judea
        family: Pearl
  - id: korb
    type: book
    publisher: Chapman and Hall/CRC
    title: Bayesian artificial intelligence
    issued:
      year: 2003
    author:
      - given: Kevin
        family: Korb
      - given: Ann
        family: Nicholson
  - id: openmpapi
    type: webpage
    title: OpenMP Application Program Interface
    URL: http://www.openmp.org/mp-documents/OpenMP4.0.0.pdf
  - id: openmpboard
    type: webpage
    title: About the OpenMP ARB and OpenMP.org
    URL: http://openmp.org/wp/about-openmp/
  - id: mpispec
    type: webpage
    title: "MPI: A Message-Passing Interface Standard"
    URL: "http://www.mpi-forum.org/docs/mpi-3.0/mpi30-report.pdf"
  - id: bwinfo
    type: webpage
    title: "Lessons Learned From the Analysis of System Failures at Petascale: The Case of Blue Waters"
    institution: "University of Illinois at Urbana-Champaign"
    URL: "https://courses.engr.illinois.edu/ece542/sp2014/finalexam/papers/bluewaters.pdf"
  - id: cudainfo
    type: webpage
    title: "CUDA Parallel Computing Platform"
    URL: "http://www.nvidia.com/object/cuda_home_new.html"
  - id: cudaguide
    type: webpage
    title: "CUDA C Programming Guide"
    URL: "http://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html"
---

# Introduction
Inferring relations among genes requires a significant amount of data.
Bayesian networks may be used to correlate this data and extract relationships among the genes. We do not know what this relationship is, but we know it has a high likelihood of existing.
These interactions can then be used to make testable hypotheses to determine how gene interactions influence life in organisms or humans. As a result, tests can be performed in the lab with more confidence and a reduced chance of wasting time and resources.
Bayesian network learning, however, is inherently slow because it is an NP-hard algorithm @cooper. Search space reduction algorithms may be utilized to reduce the computational complexity.
K2 is a great example of a search space reduction algorithm, but introduces a new problem. K2 restricts the parent hierarchy of genes within the network, and thus introduces bias in the computed relations.
To achieve high confidence in the generated networks, an abundance of Bayesian networks need to be computed using random search space restrictions. These random search space restrictions (or topologies) remove the bias and provide results which can be interpreted at various levels of confidence.
By eliminating one problem and introducing another, we have enabled the ability of parallelization by requiring multiple units of work rather than just one faster unit of work.
Other authors describe parallel implementations that can increase the speed of Bayesian network learning @altekar @misra.
However, no libraries exist which compute multiple Bayesian networks concurrently.
This project examines the value of Bayesian network learning within a parallel environment in order to reduce the time needed to generate consensus networks using many topological inputs.
This examination is performed through implementation of the said algorithm, exploring methods available such as OpenMP, MPI, and CUDA.

This paper is an extension to initial analysis performed on the algorithm and explains the thought processes behind the implementation. The preceding publication shows why the algorithm needs to be sped up, as an increase in samples causes linear growth of the problem and introduction of additional genes causes exponential growth of the problem @firstpaper.

## Bayesian Networks
Bayesian networks capture qualitative relationships among variables within a directed acyclic graph (or DAG).
Nodes within the DAG represent variables, and edges represent dependencies between the variables @korb @pearl.
Bayesian networks have a search space which grows exponentially when introducing new nodes and not placing restrictions on the structure of the network.
This complication can be overcome by using the K2 algorithm. The K2 algorithm reduces the computational cost of learning by imposing restraints on parent node connections via topological ordering @cooper.
Here, a topology refers to a hierarchical structure of parenthood that the K2 algorithm will utilize to reduce overall computational complexity while scoring data relationships.
Restricting the parent ordering, however, creates an issue of bias, which is inherent within a constraint-based search space reduction.
Sriram @sriram proposed a solution to this issue by creating a consensus network, or the combination of multiple Bayesian networks derived from several topological inputs.
To eliminate the bias created by these restraints, many randomly generated topologies are used. By increasing the number of topological inputs, the consensus network has a greater chance of reflecting the true nature of the gene interactions with higher levels of confidence.

## OpenMP
OpenMP (or **O**pen **M**ulti-**P**rocessing) is a cross-platform, multilingual application programming interface (API) which enables parallel code portability. OpenMP consists of compiler directives and library functions which alter (parallelize) the execution of a program @openmpapi. In a nutshell, OpenMP provides means of distributing code (namely loops) across multiple threads.
An advisory board of top entities in computation controls its specification which can be implemented by various compilers to target specific system capabilities @openmpboard. This allows for functionality on a wide range of processor architectures and operating systems.
The specification includes language-specific APIs, compiler directives, and standardized environment variables @openmpapi.
The model of OpenMP is comparable to the fork-join model, but provides convenience (cross-platform) features through compiler directives. These directives consist of, but are not limited to, barriers, critical regions, variable atomicity, shared memory, and reductions @openmpapi.

OpenMP enables parallel code portability at a level which would not be achievable while retaining an ideal code climate.
OpenMP by nature allows simple, straight-forward, parallelization of loops with simple compiler directives that targets the system for which the program is compiled on.
Without OpenMP, the program would have to include many different libraries and routines to achieve parallel code across different systems. The result of this would be a program which only works on a specific set of machines, or a code base which is hard to maintain and debug when changes are made to the underlying concurrent workings.

## MPI
MPI (or **M**essage **P**assing **I**nterface) is a standard which outlines network-routed (a)synchronous communication between machines @mpispec. The execution of a program which implements MPI must be orchestrated by an executor. The executor forwards appropriate arguments to each machine in order to specify the methods for the machines to talk to one another. The MPI library is used to augment the program arguments upon execution and restore the arguments to what was forwarded to the program traditionally. The augmented arguments are then used to determine rank/role through a clean API and lays the foundation to share memory between the machines.
Fault tolerance and concurrency are implemented by the user on a per-case basis, as message sending and receiving is either blocking or asynchronous @mpispec.
MPI is most beneficial when parallelizing code across multiple machines. It should be avoided for spanning computation across multiple cores because it introduces networking overhead which is unnecessary when a solution such as OpenMP should be used.

## CUDA
CUDA is a parallel computing platform and application programming interface (API) developed by NVIDIA @cudainfo.
CUDA allows software developers to utilize CUDA-enabled GPUs for general purpose processing (or GPGPU).
CUDA introduces a concept called kernels, which are extensions of C functions that, when called, are executed in parallel by CUDA threads instead of once like regular C functions @cudaguide.
The primary use case is when work is **independent** and **many** things need to be done in parallel (e.g. scaling a vector).
Due to the structure of threads on the GPU, operations such as branches or jumps are *permitted* but **discouraged**. This is because threads run in lockstep and when a branch happens, the branches are executed serially. This means threads are suspended and do not continue execution while the opposite branch is being explored. After the branch completes and the instructions converge, all threads resume running @cudaguide. This has many detrimental performance implications.
Knowing this, the GPU is best suited for vector-operations of scaling or other arithmetic which does not branch.
The memory for CUDA also resides on the GPU itself, which means before any kernels are executed, memory must be copied to the GPU. Memory must then also be copied back to the host machine for use by the CPU @cudaguide. This adds a delay which may invalidate the benefits of CUDA for smaller workloads.

# Methodology
Testing was performed on the Blue Waters petascale machine at the University of Illinois at Urbana-Champaign. The facility is maintained by Cray and consists of 22,640 Cray XE6 machines and 3,072 XK7 machines, which are CPU-only and GPU-accelerated machines respectively. The XE6 machines consist of two 16 core AMD processors with 64 GBs of RAM. The XK7 machines consist of a single 16 core AMD processor and a NVIDIA K20X GPU @bwinfo.

Cray XE6 machines were used to perform all tests utilizing purely synthetic data. OpenMP and MPI were implemented by the Cray Compiler, Cray C version 8.3.10.
The synthetic data is in the form of a gene-by-sample matrix consisting of the presence or absence of each gene within the sample.
Each test was run five times with the mean, standard deviation, and standard error calculated.

## Processors
The first natural step to parallelizing computation is to inspect utilizing multiple cores (or threads) simultaneously on the machine. This can be done by running multiple instances of the program, or by implementing code which takes advantage of multiple cores.
Analyzing the program reveals a handful of potential places for parallelization. There are many loops which perform actions which are independent from one another, such as matrix calculations.
Operations like these tend to lend themselves best to CUDA, however, due to the way the matrices are architected, CUDA may not be applied. Matrices in the program consist of a 2-dimensional array of pointers instead of a primitive data type. Because of this, each pointer must be resolved before being copied to the CUDA card which effectively removes all the benefit of using CUDA in the first place.
This problem could be mitigated by storing the matrices as a 2-dimensional array of a primitive data type, however, would require substantial refactoring of the program and its functionality. This refactoring would require resources which exceed that of which were allocated for this research.
Since CUDA could not be utilized, OpenMP and MPI were the remaining two options. MPI would not lend itself well to this problem because these operations are being acted upon memory which is specific to the machine running the program, and would introduce unnecessary overhead and network communications. MPI could potentially slow down the program given the set of the data the program is working with.
OpenMP, however, would work perfectly for this use case. OpenMP was implemented with a simple compiler directive which sped up computation.
```c++
#pragma omp parallel for
for (...) { }
```
Additionally, other opportunities were inspected for parallelization. The next one which jumped out was the creation of a network for each individual topology.
The creation of Bayesian networks are independent from one another, and thus, networks can be asynchronously generated on the same data set.
CUDA does not lend itself well to this use case because it is not performing strictly arithmetic operations. Similarly to above, using MPI would be a waste of resources which leaves the best candidate again being OpenMP.
Implementation of this parallelization is straight-forward as Bayesian network computation does not mutate its data set. This prevents us from having to replicate the memory and increase the space complexity of the algorithm. OpenMP was implemented again with a simple compiler directive.
```c++
#pragma omp parallel for
for (...) { }
```
The previous parallelization was reversed as it was determined that parallelizing a single instruction (e.g. multiplication, addition) was detrimental to the scheduling of threads responsible for computing an individual Bayesian network.

To measure the resulting computational runtime decrease, multiple tests were performed with varying number of processors.
A single set of synthetic data was used which consisted of **10** genes and **10,000** samples.
Using an exclusively reserved machine, tests were run by varying the number of processors (up to 32) and measuring the algorithm performance for the creation of **160** Bayesian networks per gene (**1600** total).
We have reached the resource limits on the systems which we have access to, and cannot test beyond **32** cores. The selection of 10 genes and 160 Bayesian networks was arbitrarily chosen as sufficient means to measure computation time.

## Machines
Distributing the work across multiple machines requires different parameters for the code than that of OpenMP.
OpenMP cannot share memory across machines so it cannot be applied to this situation.
MPI is the prime candidate for this situation as it allows machines to send messages back and forth to share memory and communicate their responsibilities and result.
Distributing the Bayesian network learning process across multiple machines doesn't make much sense because each step is dependent on the previous, so the result would be a slower computation since calculations couldn't happen in parallel and there would be added network latency.
The main candidate for distribution would be the computation of multiple Bayesian networks, because networks are computed independent of one another and there is a large backlog of networks which need computed.
Distributing the work with MPI is surprisingly simple, as the topologies are randomly generated. This means there is no communication required prior to beginning computation.
Upon initialization, each machine must determine its rank and role by augmenting the parameters, this may be done like so.
```c
int main(int argc, char **argv) {
  int forkIndex = 0, forkSize = 1;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &forkIndex);
  MPI_Comm_size(MPI_COMM_WORLD, &forkSize);

  ...
}
```
Each machine can then determine how much work it needs to do by dividing the number of requested topologies per gene by the number of machines in the swarm.
```c
int top_d = topologies / forkSize;
int top_r = topologies % forkSize;
if (forkIndex < top_r) ++top_d;
topologies = top_d;
```
When the machines complete their share of the computation they communicate to coalesce the computed networks into a consensus network.
The master machine then saves the consensus network to the disk and completes any required other computations which are simple enough not to require being distributed across machines.

Tests were conducted to measure the impact on runtime when multiple machines were used. The same data was used from the `Processors` test. Tests were run on dedicated machines utilizing **16** processors and computing **60** Bayesian networks per gene (**600** total). The selection of 10 genes and 60 Bayesian networks was arbitrarily chosen as sufficient means to measure computation time.

# Results and Discussion
In the following tables, the standard deviation is represented by the letter `s` and the standard error is denoted by `se`.

## Processors
When increasing the number of processors, the resulting runtime decrease appears to be linear. The linear nature of the results removes the necessity for further testing between the number of cores tested.
`Figure 1` illustrates that as the number of processors increase, the runtime decreases at approximately the same rate. Exact results may be seen in `Figure 2`.

![Processor Results Graph](http://puu.sh/p5XtT/305ea28995.png)

![Processor Results Data](http://puu.sh/p5XfO/885d97190a.png)

This linear decrease is consistent with how OpenMP distributes its work. OpenMP distributes the task of an independent Bayesian network computation across multiple threads simultaneously. These independent tasks are not blocking and do not lock one another, and thus have very little contention. There is one lock after each computation which appends the network to the consensus network, but is negligible to the total time taken to compute the Bayesian networks.
OpenMP results in such low standard error because it works with memory within the program and requires no network communication like MPI. The reduction of standard error as the number of threads increase may be due to the kernel. The kernel is responsible for scheduling threads and ensuring other work on the system gets done. The increase in threads means there are more threads which may go uninterrupted by the kernel scheduling something from the operating system.

Upon completion of refactoring to transition the matrices from 2-dimensional arrays of pointers into primitive data types, there is potential for CUDA to introduce orders of magnitude of speed increase.
Currently, all matrix operations are done on a single-thread, and may potentially contain thousands of rows and columns with an expensive mathematical function.
Operations like this are ideal for the GPU as it can perform the arithmetic, with no branching, across several thousand of threads simultaneously. This has the potential of speeding up calculations beyond the added latency from copying the memory to the GPU and back to the host.

## Machines
The resulting runtime decrease also appears to be linear while increasing the number of machines. However, as the number of machines increase, overhead also increases. `Figure 3` demonstrates that as the number of machines increase, there is much more variation introduced and overhead.
Observing **64** machines and leading up to **64** machines, it can be noted that the reduction in runtime becomes less and less and then starts increasing. This increase in runtime happens when the inflection point has been reached for the given set of data. At some point, it takes longer to send the data over the network than it would be to simply compute more data on less machines.
It is important to note that an increase in resources does not necessarily mean an increase in performance, nor always one for one; see `Figure 4` for test results.

![Machine Results Graph](http://puu.sh/p5Xzp/f8b6d6241d.png)

![Machine Results Data](http://puu.sh/p5Xhw/94154679a0.png)

The standard error generally increases with the increase in machines, but this is not always true. There does not seem to be a correlation between an increase or decrease in machines with an increase or decrease in standard error, except for the general rule stated above.
This is consistent with the fact that networks are very unpredictable. Pings may vary wildly depending on other network traffic and the route which packets decide to take. Additionally, there may be other noisy neighbors on the network hogging bandwidth and causing slower transmissions. On clusters across the world wide web, traffic may have to travel through geographical displacement and suffer packet loss or increases in latency.
The only thing consistent with the standard error is that it is not consistent.

# Conclusion
By generating a consensus network out of many Bayesian networks, researchers may screen and infer new gene interactions. This allows researchers to feel more confident about testing hypotheses in the lab, such that their resources and time will not be wasted.
We have concluded that utilizing parallelization through means of OpenMP and MPI substantially reduces the time to generate a consensus network. This parallelization, however, is computing multiple Bayesian networks simultaneously with no implemented accelerations for the network learning itself.
The search space reduction, K2, was a great start but there may still be room to improve with CUDA. Future work contains plans to implement the CUDA accelerations for the matrix operations that happen within the Bayesian network learning algorithm, but is significantly more difficult than the OpenMP and MPI implementation.
The motivation for this is that CUDA has the potential to speed the algorithm up by several orders of magnitude.
Additionally, the speedup of OpenMP and MPI have limits which we cannot break without exploring CUDA acceleration. As demonstrated in the graphs above, an increase in resources must be tailored to the problem at hand. Increasing the resources too significantly becomes detrimental, resulting in costly waste; see `Figure 3`.

Working on this project gave me a massive amount of experience, which far surpassed what I thought it would.
I gained experience in professional writing for journal publications and renewed my skills in proofreading.
I also gained exposure to a whole new aspect of project organization which I was not used to: meetings with advisors, progress reports, and demos.
I feel like this has really helped foster my professional identity and prepared me more for higher education and the workforce.
Additionally, I flexed my problem solving skills while implementing the algorithm and begun refactoring. The refactoring had to be done in such a fashion to allow for parallelization. This presented some challenges because there were also memory considerations to make things sharable over the network (MPI).
Overall, I learned many invaluable skills which will be applied to my future education and work.
Notably, I performed my first publication @firstpaper and gave a presentation at the conference, then presented a poster version of the paper at GLBIO 2016 to draw attention to the work.

# Acknowledgments
This research is part of the Blue Waters sustained-petascale computing project, which is supported by the National Science Foundation (awards OCI-0725070 and ACI-1238993) and the state of Illinois. Blue Waters is a joint effort of the University of Illinois at Urbana-Champaign and its National Center for Supercomputing Applications.

Additional financial support was provided by the Buchtel College of Arts and Sciences at The University of Akron.
Further support was provided by a grant from the Choose Ohio First Bioinformatics scholarship.

The data, statements, and views within this paper are solely the responsibility of the authors.

# References
