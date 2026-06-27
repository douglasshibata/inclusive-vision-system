import { Component, signal, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div [class.high-contrast]="isHighContrast()">
      <main class="ivs-container" role="main">
        <header>
          <h1 class="sr-only">Inclusive Vision System Dashboard</h1>
          <nav aria-label="Main Navigation">
            <button (click)="toggleHighContrast()" [attr.aria-pressed]="isHighContrast()">
              Toggle High Contrast
            </button>
          </nav>
        </header>

        <section class="analysis-panel" aria-labelledby="analysis-heading">
          <h2 id="analysis-heading">Scene Analysis</h2>

          <div class="video-preview" role="region" aria-label="Live Video Feed">
            <!-- Video feed placeholder -->
            <p>Live feed active. Screen reader will announce results.</p>
          </div>

          <div class="results" aria-live="polite">
            @if (analysis()) {
              <p>{{ analysis() }}</p>
            } @else {
              <p>Waiting for analysis...</p>
            }
          </div>

          <button (click)="runMockAnalysis()" class="btn-analyze">
            Run Manual Analysis
          </button>
        </section>
      </main>
    </div>
  `,
  styles: [`
    .ivs-container {
      padding: 2rem;
      max-width: 800px;
      margin: 0 auto;
      min-height: 100vh;
    }
    .analysis-panel {
      margin-top: 2rem;
      border: 1px solid #ddd;
      padding: 1.5rem;
      border-radius: 8px;
    }
    .btn-analyze {
      margin-top: 1rem;
      padding: 0.75rem 1.5rem;
      font-size: 1rem;
      cursor: pointer;
    }
  `]
})
export class AppComponent {
  isHighContrast = signal(false);
  analysis = signal<string | null>(null);

  private http = inject(HttpClient);

  toggleHighContrast() {
    this.isHighContrast.update(v => !v);
  }

  runMockAnalysis() {
    this.analysis.set('Processing image...');

    // In a real app, this would call the Python AI Engine
    // this.http.post<any>('/api/v1/analyze/image', {}).subscribe(...)

    setTimeout(() => {
      this.analysis.set('Analysis: A bright office space with three people collaborating.');
    }, 1500);
  }
}
