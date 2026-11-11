import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  standalone: true,
  template: `
    <main class="dashboard" role="main">
      <header>
        <h1>Inclusive Vision System (IVS) - Caregiver Dashboard</h1>
      </header>
      <section aria-labelledby="status-heading">
        <h2 id="status-heading">Telemetria em Tempo Real</h2>
        <p>Monitoramento ativo de usuários, alertas hápticos e streams espaciais.</p>
      </section>
    </main>
  `,
  styles: [`
    .dashboard {
      padding: 2rem;
      max-width: 1200px;
      margin: 0 auto;
    }
    header {
      border-bottom: 2px solid #e2e8f0;
      padding-bottom: 1rem;
      margin-bottom: 2rem;
    }
  `]
})
export class AppComponent {
  title = 'IVS Web Dashboard';
}
