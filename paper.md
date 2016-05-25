---
title: "STUDENT PAPER: An Implementation of Parallel Bayesian Network Learning"
author:
  - Joseph Haddad
  - Timothy W. O'Neil
tags: [Computing]
abstract: |
  this is a short abstract
references:
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
---

# Introduction
Inferring relations among genes requires a significant amount of data.
Bayesian networks may be used to correlate this data and extract relationships among the genes. We do not know what this relationship is, but we know it has a high likelihood of existing.
These interactions can then be used to make testable hypotheses to determine how gene interactions influence life in organisms or humans. As a result, tests can be performed in the lab with more confidence and a reduced chance of wasting time and resources.
Bayesian network learning, however, is inherently slow because it is an NP-hard algorithm @cooper. To reduce the computational complexity, search space reduction algorithms may be utilized.
K2 is a great example of a search space reduction algorithm, but introduces a new problem. K2 restricts the parent hierarchy of genes within the graph, and thus introduces bias in the computed relations.
To achieve high confidence in the generated networks, an abundance of Bayesian networks need to be computed using random search space restrictions. These random search space restrictions remove the bias and provide results which can be interpreted at various levels of confidence @sriram.
By eliminating one problem and introducing another, we have enabled the ability of parallelization by requiring multiple units of work rather than just one faster unit of work.
Other authors describe parallel implementations that can increase the speed of Bayesian network learning (cite).
However, no libraries exist which compute multiple Bayesian networks concurrently.
This project examines the value of Bayesian network learning within a parallel environment in order to reduce the time needed to generate consensus networks using many topological inputs.
This examination is performed through implementation of said algorithm, utilizing various methods available such as OpenMP, MPI, and CUDA.

## Bayesian Networks
Bayesian networks capture qualitative relationships among variables within directed acyclic graphs (or DAGS).
Nodes within the DAG represent variables, and edges represent dependencies between said variables @korb @pearl.
Bayesian networks have a search space which grows exponentially when introducing new data and not placing restrictions on the structure of the network.
This complication can be overcome by using the K2 algorithm. The K2 algorithm reduces the computational cost of learning by imposing restraints on parent node connections via topological ordering @cooper.
Restricting the parent ordering, however, creates an issue of bias, which is inherent within a constraint-based search space reduction.
Sriram @sriram proposed a solution to this issue by creating a consensus network, or the combination of multiple Bayesian networks derived from several topological inputs.
Here, a topology refers to a hierarchical structure of parenthood that the K2 algorithm will utilize to reduce overall computational complexity while scoring data relationships.
To eliminate the bias created by these restraints, many randomly generated topologies are used. By increasing the number of topological inputs, the consensus network has a greater chance of reflecting the true nature of the gene interactions with higher levels of confidence.

## OpenMP
OpenMP (or **O**pen **M**ulti-**P**rocessing) is a cross-platform, multilingual application programming interface (API) which enables parallel code portability. OpenMP consists of compiler directives and library functions which alter (parallelize) the execution of a program @openmpapi. In a nutshell, OpenMP provides means of distributing code (namely loops) across multiple threads.
An advisory board of top entities in computation controls its well-defined specification which can be implemented by various compilers to target specific system capabilities @openmpboard. This allows functionality on a wide range of processor architectures and operating systems.
The specification includes language-specific APIs, compiler directives, and standardized environment variables @openmpapi.
The model of OpenMP is comparable to the fork-join model, but provides convenience (cross-platform) features through compiler directives. These directives consist of, but are not limited to, barriers, critical regions, variable atomicity, shared/private memory, and reductions @openmpapi.

OpenMP enables parallel code portability at a level which would not be achievable while retaining an ideal code climate.
OpenMP by nature allows simple, straight-forward, parallelization of loops with simple compiler directives that targets the system the program is compiled on.
Without this library, the program would have to include many different libraries and routines to achieve parallel code across different systems. The result of this would be a program which only works on a specific set of machines, or a code base which is hard to maintain and debug when changes are made to the underlying concurrent workings.

TODO: explain kernel scheduling and OS etc and potential overhead

## MPI
MPI (or **M**essage **P**assing **I**nterface) is a standard which outlines network-routed (a)synchronous communication between machines @mpispec. The execution of a program which implements MPI must be orchestrated by an executor. The executor forwards appropriate arguments to each machine in order to specify the methods for the machines to talk to one another. The MPI library is used to augment the program arguments upon execution and restore the arguments to what was forwarded to the program traditionally. The augmented arguments are then used to determine rank/role through a clean API and lays the foundation to share memory between the machines.
Fault tolerance and concurrency are implemented by the user on a per-case basis, as message sending and receiving is either blocking or asynchronous @mpispec.
MPI is most beneficial when parallelizing code across multiple machines. It should be avoided for spanning computation across multiple cores because it introduces networking overhead which is unnecessary when a solution such as OpenMP should be used.

## CUDA
TODO: overview of cuda

# Methodology
Testing was performed on the Blue Waters petascale machine at the University of Illinois at Urbana-Champaign. The facility is maintained by Cray and consists of 22,640 Cray XE6 machines and 3,072 XK7 machines, which are CPU-only and GPU-accelerated machines respectively. The XE6 machines consist of two 16 core AMD processors with 64 GBs of RAM. The XK7 machines consist of a single 16 core AMD processor and a Nvidia K20X GPU @bwinfo.

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
Distributing the work with MPI is surprisingly simple, as the topologies are randomly generated. This means there is no communication required prior to beginning computation. Each machine can determine how much work it needs to do by dividing the number of requested topologies per gene by the number of machines in the swarm.
When the machines complete their share of the computation they communicate to coalesce the computed networks into a consensus network.
The master machine then saves the consensus network to the disk and completes any required other computations which are simple enough not to require being distributed across machines.

Tests were conducted to measure the impact on runtime when multiple machines were used. The same data was used from the `Processors` test. Tests were run on dedicated machines utilizing **16** processors and computing **60** Bayesian networks per gene (**600** total). The selection of 10 genes and 60 Bayesian networks was arbitrarily chosen as sufficient means to measure computation time.

# Results and Discussion
## Processors
TODO: results of processor scaling
TODO: potential of cuda with rearchitecting

## Machines
TODO: results of node scaling

# Conclusion
TODO: conclude results
TODO: reflect on the experience including such things as project organization, challenges, and solutions as well as the impact of the project on the students’ education and career outlook

# Acknowledgments
This research is part of the Blue Waters sustained-petascale computing project, which is supported by the National Science Foundation (awards OCI-0725070 and ACI-1238993) and the state of Illinois. Blue Waters is a joint effort of the University of Illinois at Urbana-Champaign and its National Center for Supercomputing Applications.

# References
