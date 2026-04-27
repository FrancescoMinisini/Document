TEMPO TOTALE: circa 11 Minuti conservativi (10.40) leggendo

# Slide 0 (20s)
Buongiorno, sono Francesco Giuseppe Minisini e oggi presento il lavoro svolto per la mia tesi triennale. Il progetto si è sviluppato attorno a un'applicazione di Deep reinforcement learning su una task di quantum control su un'architettura di qubit superconduttori. 

# Slide 1 (50s)
Per lo sviluppo di quantum devices sempre piu complessi e affidabili, è necessaria la realizzazione di quantum gates ad alta fedeltà veloci e robusti al rumore.

Un'architettura promettente risulta essere quella dei qubits superconduttori: dei circuiti ultra-raffreddati che simulano il comportamento diun atomo artificiale, il cui ground state e primo livello eccitato sono utilizzati come sottospazio computazionale.

I qubits superconduttori presentano però una debole anarmonicità, il che può permettere a rumore o controlli ad eccitare il sistema a livelli energetici superiori andando a perdere l'informazione quantistica. Questo processo si chiama Leakage o perdita.

Ci tengo inoltre a specificare che la task di controllo quantistico analogico consiste nella esecuzione di una operazione quantistica manipolando la dinamica del sistema tramite l'introduzione di impulsi di controllo direttamente a livello dell'Hamiltoniana.

# Slide 2 (1min 40s)

L'implementazione di una operazione quantistica presenta diversi obbiettivi devono essere soddisfatti simultaneamente:

- Fedeltà dell'operazione
- Bassa leakage
- Robustezza al rumore
- Esecuzione rapida esecuzione

Il deep reinforcement Learining rappresenta una ottimo candidato per risolvere questo tipo di problemi:
- il problema puo essere formulato come un Markov decision Process
- l'agente puo sfruttare regolarità non locali nello spazio di traiettorie, inaccessibili a tecniche classiche 
- transfer learning puo essere utilizzato per task simili 

# Slide 3 (1min)

L'obbiettivo scientifico della tesi è stato quello di implementare ed eseguire una valutazione indipendente del framework proposto nel paper di Nature Universal Quantum Control throu Deep Reinforcement  M. Y. Niu, S. Boixo, V. N. Smelyanskiy, and H. Neven.

Ci tengo a specificare che, a causa di mancanza di codice pubblico, una gran parte del lavoro è stata l'implementazione del framework da zero, il quale è composto da diversi componenti. Ciascuno con le proprie sfide tecniche e conoscenze pregresse che ho dovuto acquisire.

Tra cui:
- Quantum Environment simulator of two-qubit gmon architecture   (through the QuTip framework) 
- Leakage estimator
- Full Deep Reinforcement Learning pipeline (neural networks, training curriculum, evaluation), coupled with Trust Region Policy Optimization 
- Optimization to make the framework computationally feasible
- Scrittura di ciascun esperimento e valutazione
 
# Slide 4 (40s)
Passando alla dinamica del sistema, viene qui riportata l'hemiltoniana del sistema. I primi tre termini sono nativi della architettura gmon, mentre l'ultimo termine descrive un microwave drive per il controllo delle operazioni.

Evidenziate in rosso sono i parametri regolabili dipendenti dal tempo, attraverso i quali l'agente cercherà di ottimizzare la dinamica del sistema. 

Essi vanno perciò a formare il vettore di controllo, che costituisce proprio l'output dell'agente.

Perciò, una soluzione al problema di controllo avrà la forma di una successione di questi vettori di controllo.

# Slide 5 (1m 40s)

La formulazione RL della task consiste nella definizione di agente e ambiente. L'agente conincide  con un Policy NN, il quale dato l'input dello stato del sistema, approssima una gaussiana 7 dimensionale sullo spazio delle azioni, da cui poi viene campionata una azione. Viene quindi simulata l'azione all'interno dell'ambiente, la quale evolve il sistema a un nuovo stato che verrà poi rimandato all'agente per l'iterazione successiva.

Il training avviene invece dopo aver raccolto una batch di transizioni. La value network stima il ritorno atteso degli stati e permette di calcolare l’advantage, cioè quanto l’azione scelta è stata migliore o peggiore del previsto.

TRPO usa questi advantage per aggiornare la policy, mantenendo però la nuova policy vicina alla precedente tramite un vincolo di trust region. In parallelo, anche la value network viene aggiornata tramite una value loss, così da fornire stime migliori nelle batch successive.

Quindi, in sintesi: la policy sceglie i controlli, l’ambiente simula la dinamica quantistica, la value network valuta la traiettoria, e TRPO aggiorna la policy una batch alla volta.

# Slide 6 (45s)

La cost function è la metrica fondamnentale che viene minimizzata dall'agente. Per questo essa risulta una somma pesata esplicita di vari termini, ciascuno associato a uno degli obbiettivi precedentemente menzionati.

Il primo per minimizzare l'infedeltà, il secodo per minimizzare la probabilità che il sistema transiti verso uno stato non computazionale, il terzo per garantire soddisfazione delle condizioni al contorno, e il quarto per minimizzare il tempo di esecuzione.

Importante sottolineare che questi non sono automaticamente compatibili tra loro, l'ottimizzazione per un obbiettivo potrebbe andare a penalizzare un altro. (possibile rimuovere)

# Slide 7 (1m 20)

Gli esperimenti eseguiti coinvolgono diverse varianti di agenti di controllo.

- Uno classico, basato su tecnica di gradient descent (Adam) pulse optimization della cost function precedentemente descritta.
- E quello di RL in varie configurazioni.

Gli esperimenti eseguiti sono multipli. In particolare:
- Extensive parameter study:
    - neural network sizes and layouts per studiarne i differenti trade-off tra performance e stabilità
    - UFO cost function weights per studiare la relazione tra i differenti obbiettivi della cost function
- Single-target benchmark: confronto tra performance di Adam e RL agent su task specifiche
- Robustness under noise: robustezza dei risultati di Adam vs RL agent a diversi livelli di rumore
- Consistency of performance: stabilità di performance di Adam vs RL agent su diversi target
- Transfer Learning Evaluation: valutazione della capacità di transfer learning

# Slide 8 (25s)

Per vincoli di tempo, mostro solo i risultati essenziali.

Paragonando le performance dell RL agent con Adam, in condizioni nominali in un esperimento a target singolo, si notano superiori performance da parte della tecnica di ottimizzazione classica su metriche di fidelity leakage e runtime.

# Slide 9 (1m 20s)

Particolarmente interessante risulta essere invece la valutazione della robustezza delgi agenti sottoposti al rumore gaussiano.
In questa valutazione è stata introdotta il cosiddetto agente noise optimized, allenato in un ambiente con rumore gaussiano fisso di 1 MHz.

I grafici mostrano la fedeltà media e la sua deviazione standard su un campione di 60 esperimenti per datapoint, il cui ambiente è sottoposto ad rumore gaussiano di deviazione standard crescente. (I risultati mostrati sono delle medie mobili).

Come possiamo notare è una complessiva performace superiore da parte dell' agende allenato con rumore, sia in termini di fedeltà media, sia in termini di precisione su tutto il dominio testato.

Possiamo interpretare questo risultato come la capacità dell'agente di generalizzare e acquisire policy più conservative, risultando complessivamente meno sensibili a rumore esterno.

Da notare inoltre come l'agente Adam, ancora performi meglio di quello RL nominale, il che suggerisce che la miglior performance del agente noise optimized non sia dovuto ad una mera applicazione di RL, ma la sua capacità di generalizzare in ambiente rumoroso.

# Slide 10 (40s)

Qui sono invece elencati altri risultati interessanti ottenuti nella tesi ma non presentati più nel dettaglio per ragioni di tempo.

Riassumendo, la tesi ha contribuito con la completa reimplementazione del framework e l'estensione della letteratura esistente, tramite vari risultati e un piu approfondito paragone tra la controparte classica.

Tra le conclusioni scientifiche possiamo trarre che sotto perturbazioni stocastiche, l'agente allenato in ambiente rumoroso diventa la miglior strategia.