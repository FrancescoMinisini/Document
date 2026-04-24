## Slide 0 — Title (Tempo indicativo: 20–25 secondi)

“Buongiorno a tutti, oggi vi presento il mio lavoro di tesi, intitolato Reinforcement-Learning Framework for Robust and Universal Analog Quantum Control on Superconducting Qubits.

L’obiettivo della tesi è stato ricostruire e valutare criticamente un framework di controllo quantistico proposto in letteratura, basato su reinforcement learning, per la realizzazione di gate quantistici robusti su qubit superconduttivi.” 


## Slide 1 — Why this problem matters (Tempo indicativo: 55 secondi)

“Il punto di partenza è che, nei qubit superconduttivi, progettare un gate quantistico non significa solo massimizzare la fedeltà logica.

In pratica, bisogna bilanciare contemporaneamente più obiettivi fisici: ottenere un gate accurato, farlo in tempi brevi, limitare il leakage fuori dal sottospazio computazionale e rendere il controllo robusto rispetto al rumore.

Il problema nasce dal fatto che questi sistemi non sono perfettamente a due livelli: sono solo debolmente anarmonici. Questo significa che, se il controllo è troppo rapido o troppo aggressivo, si rischia facilmente di eccitare livelli indesiderati.

Quindi il controllo quantistico realistico, in questo contesto, è intrinsecamente un problema multi-obiettivo: non basta fare un gate corretto, bisogna farlo in modo fisicamente ben comportato.”

## Slide 2 — Thesis goals and main contribution (Tempo indicativo: 1 minuto)

“La tesi aveva un doppio obiettivo.

Il primo era scientifico: capire se il framework proposto da Niu e collaboratori fosse davvero una strategia credibile per il controllo analogico robusto.

Il secondo era metodologico: ricostruire il framework in modo indipendente e poi validarlo sperimentalmente.

Ed è importante sottolineare un aspetto: questo non è stato un lavoro di semplice riproduzione da codice esistente. Non era disponibile una implementazione pubblica completa, quindi ho dovuto ricostruire l’intero framework da zero.

Questo ha incluso la simulazione multilevel del sistema quantistico, la stima del leakage tramite la trasformazione di Schrieffer–Wolff dipendente dal tempo, l’ambiente di reinforcement learning con agente TRPO, e tutta la pipeline di training, valutazione, robustezza e analisi dei runtime.

Quindi una parte molto rilevante della tesi è stata proprio la costruzione del framework, non solo la sua esecuzione.”

## Slide 3 — Physical model: gmon Hamiltonian and control channels (Tempo indicativo: 1 minuto e 10 secondi)

“Dal punto di vista fisico, il sistema considerato è un’architettura di tipo gmon, cioè due qubit superconduttivi debolmente anarmonici con accoppiamento modulabile.

L’Hamiltoniana efficace in rotating-wave approximation contiene quattro ingredienti principali:
l’anarmonicità, che rende il sistema multilevel;
il termine di coupling tunabile, che genera la dinamica entangliante;
i detuning locali;
e i drive a microonde, con ampiezza e fase controllabili.

Alla fine il problema di controllo è descritto da un vettore continuo a sette dimensioni:
il coupling g(t),
due detuning,
due ampiezze di microonda,
e due fasi.

Questa è già una prima difficoltà importante: non stiamo ottimizzando pochi parametri discreti, ma una traiettoria di controllo continua in uno spazio a sette dimensioni, su un sistema fisico multilevel.

Nel mio caso, per rendere la simulazione trattabile ma fisicamente significativa, ogni modo locale è stato troncato a tre livelli, ottenendo quindi uno spazio fisico di dimensione 9, mentre il sottospazio computazionale resta di dimensione 4.”

## Slide 4 — Why this is a multi-objective control problem (Tempo indicativo: 1 minuto e 15 secondi)

“Questa slide mostra il cuore concettuale del framework: la funzione costo UFO.

L’idea è che il problema venga esplicitamente formulato come problema multi-obiettivo. Il costo totale è la somma di quattro contributi.

Il primo è la fidelity penalty, cioè quanto il gate implementato si discosta dal gate target.

Il secondo è la leakage penalty, che penalizza la perdita di popolazione fuori dal sottospazio computazionale.

Il terzo è la boundary penalty, che impone che gli impulsi siano regolari agli estremi temporali, quindi che il pulse parta e finisca in modo ben controllato.

L’ultimo è la time penalty, che scoraggia soluzioni troppo lunghe.

Questa struttura è molto importante perché rende esplicito che i vari obiettivi non sono automaticamente compatibili.

In particolare, il termine di leakage non è un semplice numero empirico, ma una proxy fisicamente motivata, costruita a partire da una trasformazione di Schrieffer–Wolff dipendente dal tempo. I termini ai bordi penalizzano accoppiamenti residui all’inizio e alla fine del pulse, mentre il termine integrale penalizza variazioni temporali troppo brusche.

Quindi il punto chiave è: il controllo qui non cerca solo di fare bene il gate, ma di farlo bene secondo più criteri fisici simultaneamente.”

## Slide 5 — RL formulation (Tempo indicativo: 55 secondi)

“A questo punto il problema viene riformulato come problema di reinforcement learning continuo.

L’agente osserva lo stato corrente del sistema, che nel framework è rappresentato a partire dal propagatore corrente, quindi da quanto del gate è già stato costruito.

L’azione consiste nel proporre il prossimo vettore di controllo continuo.

L’ambiente poi prende quell’azione, costruisce l’Hamiltoniana corrispondente, evolve il sistema quantistico multilevel e restituisce una reward, che è semplicemente il negativo della funzione costo UFO.

L’algoritmo usato è TRPO, cioè Trust Region Policy Optimization, in una formulazione actor–critic.

Due parole in piu su come e quando avvengono gli update delle nns considerando trpo

Questa scelta è interessante perché il controllo dei pulse ha una struttura sequenziale naturale: il pulse viene costruito passo dopo passo, e il reinforcement learning è una maniera coerente di trattare questo processo come una decisione sequenziale in tempo.”

## Slide 6 — Evaluation metrics & target gate family (Tempo indicativo: 1 minuto)

“Per valutare il framework, tutti gli esperimenti sono stati fatti su una famiglia continua di gate target, indicata qui come N(α,α,γ).

Questa famiglia è utile perché è abbastanza ricca da contenere gate fisicamente interessanti, ma allo stesso tempo abbastanza strutturata da permettere confronti sistematici.

Le metriche usate sono quattro.

La prima è la gate fidelity, che misura l’accuratezza logica del gate sul sottospazio computazionale.

La seconda è la leakage proxy, che stima quanto la dinamica esca dal sottospazio desiderato.

La terza è la average fidelity under noise, cioè la fedeltà media ottenuta facendo molte realizzazioni Monte Carlo in presenza di rumore.

La quarta è la fidelity variance, che misura la stabilità shot-to-shot: non basta avere una buona media, bisogna anche avere una bassa dispersione.

Queste metriche sono importanti perché separano chiaramente accuratezza nominale, comportamento multilevel e robustezza stocastica.”

## Slide 7 — Implemented controllers and experimental campaign (Tempo indicativo: 1 minuto)

“Prima di mostrare i risultati, qui chiarisco quali controller ho effettivamente implementato e quali campagne sperimentali ho eseguito.

Ho considerato tre varianti principali.

La prima è una baseline Adam, cioè ottimizzazione diretta dei pulse con gradient descent su orizzonti temporali fissati.

La seconda è un agente TRPO nominale, addestrato in ambiente deterministico.

La terza è un agente TRPO noise-optimized, cioè addestrato direttamente in presenza di perturbazioni gaussiane sui controlli e sull’anarmonicità efficace.

La distinzione fondamentale tra nominal e noise-optimized non è nella fisica del modello né nell’architettura della rete, ma nell’ambiente di training.

Su questa base ho poi eseguito una campagna sperimentale estesa:
benchmark single-target,
analisi di robustezza in funzione del rumore,
sweep family-wide sui gate,
curriculum runtime sweep,
e studio sistematico dei parametri.

Questo è importante perché la validazione del framework non si basa su un singolo esperimento, ma su una serie strutturata di test complementari.”

## Slide 8 — Extended parameter study (Tempo indicativo: 1 minuto e 15 secondi)

“Questa slide è molto importante, perché nel reinforcement learning le scelte dei parametri influenzano in modo forte stabilità, convergenza e qualità finale del controllo. Estensione della letteratura esistente.

Per questo ho dedicato una parte estesa del lavoro a uno studio dei parametri in cui si è ripetuto una ottimizzazione di un single target su vari seed, con però un curriculum di apprendimento ridotto rispetto ai successivi risultati.

Da un lato ho studiato l’architettura delle reti policy e value, confrontando diverse topologie. Il risultato è che la performance dipende in modo misurabile dalla capacità della rete, ma non in modo monotono: reti più grandi non migliorano automaticamente i risultati. Alla fine ho mantenuto l’architettura 64,32,32, che era anche quella più fedele al paper.

Dall’altro lato ho fatto una sensitivity analysis sui pesi della funzione costo UFO. Questo è ancora più delicato, perché quei pesi non sono semplici iperparametri numerici: definiscono il bilanciamento fisico tra fedeltà, leakage, regolarità ai bordi e tempo.

Il risultato importante è che la scelta originale del paper, cioè 10,10,0.2,0.1, è rimasta vicina alla regione migliore anche nella mia implementazione.

Diverse osservazioni sono state eseguite sulla validità dei risultati e sulle limitazioni degli stessi esperimenti.

Quindi questo studio mi ha permesso di fissare una configurazione finale stabile e interpretabile, evitando che i risultati dipendessero da tuning arbitrario.”

Questi esperimenti sono stati ripetuti su vari seed e i valori plottati sono le averages di questi

## Slide 9 — Single-target optimization: Dynamics and Horizon (Tempo indicativo: 1 minuto)

“Passando ai risultati, il primo benchmark è sul gate rappresentativo N(2.2,2.2,π/2).

A sinistra si vede la dinamica di training del controller TRPO nominale: quello che emerge è che la fedeltà entra abbastanza rapidamente in un regime alto, mentre la parte più difficile del training diventa il bilanciamento tra leakage, tempo e costo totale.

A destra si vede invece lo sweep sugli orizzonti temporali della baseline Adam.

Il risultato numerico è che, su questo singolo target nominale, Adam trova una soluzione migliore di TRPO: runtime più corto, costo più basso, fedeltà leggermente più alta e leakage significativamente più basso.

Questo è un risultato metodologicamente importante, perché mostra che il reinforcement learning non domina automaticamente una forte baseline di ottimizzazione diretta nel regime deterministico.”

## Slide 10 — Adam vs TRPO and Family-wide evaluation (Tempo indicativo: 55 secondi)

“Qui rendo più esplicito il confronto.

Sul singolo target nominale, Adam domina il TRPO nominale in tutte le metriche principali. Questo suggerisce che, quando il problema è fisso, deterministico e pienamente differenziabile, l’ottimizzazione diretta resta estremamente competitiva.

Sotto, però, si vede anche lo sweep family-wide della baseline Adam sulla famiglia N(α,α,π/2). Ed è interessante notare che la difficoltà del problema non è uniforme lungo la famiglia: esiste una regione centrale molto più favorevole e regioni ai bordi decisamente più difficili.

Questo punto sarà importante dopo, perché ci aiuta a distinguere tra difficoltà intrinseca della famiglia di gate e vantaggi specifici del framework RL.”

## Slide 11 — Noise-optimized Agent: Robustness (Tempo indicativo: 1 minuto e 15 secondi)

“Questa è probabilmente la slide più importante dei risultati.

Quando introduco rumore gaussiano sui controlli, il controller noise-optimized diventa il migliore tra quelli considerati.

Nel grafico di sinistra vedete la average fidelity in funzione dell’intensità del rumore: il controller addestrato in ambiente stocastico definisce praticamente l’inviluppo superiore della comparazione.

Nel grafico di destra vedete la fidelity variance: anche qui il noise-optimized ha sistematicamente la dispersione minore.

Questo è il risultato centrale della tesi sul lato robustezza. La differenza tra nominal TRPO e noise-optimized TRPO non è nell’architettura o nel modello fisico, ma solo nell’ambiente di training. Quindi il miglioramento non può essere attribuito genericamente al reinforcement learning, ma al fatto che la robustezza venga effettivamente appresa esponendo il controller al rumore già durante l’addestramento.

In altre parole: il framework non è particolarmente convincente come nominal optimizer universale, ma diventa molto convincente quando il problema viene trattato come problema robusto.”

## Slide 12 — Runtime across the gate family (Tempo indicativo: 1 minuto e 10 secondi)

“L’ultima grande analisi riguarda il runtime lungo la famiglia N(α,α,π/2).

Qui il dato importante è che il profilo dei runtime non è uniforme, ma altamente strutturato. C’è una regione centrale in cui i controlli analogici trovati dal framework sono molto più rapidi, e regioni ai bordi in cui il problema torna più difficile.

Il confronto di riferimento è con il gate synthesis standard, che nel paper corrisponde a circa 215 nanosecondi.

Su una parte ampia della famiglia, i controller analogici restano al di sotto di questa baseline, spesso anche in modo netto.

La lettura fisica è che il vantaggio massimo appare quando il gate target è meglio allineato con l’interazione nativa dell’Hamiltoniana gmon. In quelle regioni il controller non deve “forzare” troppo il sistema: può sfruttare direttamente la struttura naturale del dispositivo.

Quindi il vantaggio sul runtime non è casuale né uniforme: è un effetto fisicamente strutturato, che dipende dall’allineamento tra target gate e dinamica nativa del sistema.”

## Slide 13 — Conclusions (Tempo indicativo: 1 minuto)

“Per concludere, il quadro finale è il seguente.

Sono riuscito a ricostruire da zero un framework complesso che combina simulazione quantistica multilevel, stima fisicamente motivata del leakage e reinforcement learning continuo.

Dal punto di vista empirico, la tesi mostra che il reinforcement learning non è automaticamente superiore all’ottimizzazione diretta nel regime nominale single-target.

Però mostra anche, in modo piuttosto chiaro, che quando il problema viene formulato nel modo corretto, cioè includendo esplicitamente il rumore nell’ambiente di training, allora il controller RL diventa la strategia più forte in termini di robustezza.

Inoltre, l’analisi sui runtime supporta l’idea che il controllo analogico possa superare la gate synthesis standard in regioni della famiglia di gate ben allineate con la fisica nativa del dispositivo.

Quindi il messaggio finale è questo: il valore principale di questo framework non sta in una superiorità nominale universale, ma nel fornire una strategia unificata, leakage-aware, robusta e fisicamente significativa per il controllo analogico quantistico realistico. Ma una definitiva superiorità, quantomeno per runtime metric rispetto a compiled circuit approach

Grazie.”