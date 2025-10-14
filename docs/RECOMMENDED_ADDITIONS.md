# Recommended Additions to Vertex Templates

> **Purpose**: These are recommended patterns and implementations that are NOT currently in your templates but could enhance the Vertex platform.

## 🚨 Status: Not Currently Implemented

**Important**: Everything in this document represents recommendations for future enhancements, not current implementations in your templates.

---

## 🔧 Performance & Monitoring Enhancements

### Performance Monitoring Middleware
```csharp
public class PerformanceMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<PerformanceMiddleware> _logger;
    
    public async Task InvokeAsync(HttpContext context)
    {
        var stopwatch = Stopwatch.StartNew();
        
        await _next(context);
        
        stopwatch.Stop();
        
        if (stopwatch.ElapsedMilliseconds > 500)
        {
            _logger.LogWarning("Slow request: {Method} {Path} took {ElapsedMs}ms",
                context.Request.Method,
                context.Request.Path,
                stopwatch.ElapsedMilliseconds);
        }
    }
}
```

### Enhanced Caching Service
```csharp
public class CachedTemplateService : ITemplateService
{
    private readonly ITemplateService _templateService;
    private readonly IMemoryCache _cache;
    
    public async Task<Template> GetTemplateAsync(int id)
    {
        var cacheKey = $"template-{id}";
        
        if (_cache.TryGetValue(cacheKey, out Template cached))
            return cached;
            
        var template = await _templateService.GetTemplateAsync(id);
        _cache.Set(cacheKey, template, TimeSpan.FromMinutes(15));
        
        return template;
    }
}
```

---

## 📊 Enhanced Data Patterns

### Pagination Support
```csharp
public class PagedResult<T>
{
    public IEnumerable<T> Items { get; set; } = [];
    public int TotalCount { get; set; }
    public int Page { get; set; }
    public int PageSize { get; set; }
    public int TotalPages => (int)Math.Ceiling((double)TotalCount / PageSize);
}

public record GetInventoryItemsQuery(
    string? SearchTerm = null,
    int Page = 1,
    int PageSize = 20) : IRequest<PagedResult<InventoryItem>>;
```

### Advanced Filtering
```csharp
public class InventoryItemFilter
{
    public string? SearchTerm { get; set; }
    public DateTime? CreatedAfter { get; set; }
    public DateTime? CreatedBefore { get; set; }
    public decimal? MinQuantity { get; set; }
    public decimal? MaxQuantity { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 20;
}
```

---

## 📚 Storybook Integration

### Storybook Setup for Component Documentation
```bash
# Install Storybook dependencies
npx storybook@latest init

# Additional addons for Vertex components
npm install --save-dev @storybook/addon-essentials @storybook/addon-a11y @storybook/addon-docs
```

### Storybook Configuration for VxFileUpload and Custom Components
```typescript
// .storybook/main.ts
export default {
  stories: ['../src/**/*.stories.@(js|jsx|ts|tsx|mdx)'],
  addons: [
    '@storybook/addon-essentials',
    '@storybook/addon-a11y',
    '@storybook/addon-docs',
  ],
  framework: {
    name: '@storybook/angular',
    options: {},
  },
  typescript: {
    check: false,
    checkOptions: {},
    reactDocgen: 'react-docgen-typescript',
    reactDocgenTypescriptOptions: {
      shouldExtractLiteralValuesFromEnum: true,
      propFilter: (prop) => (prop.parent ? !/node_modules/.test(prop.parent.fileName) : true),
    },
  },
};
```

### Enhanced VxFileUpload Stories
```typescript
// Enhanced stories for VxFileUpload component with comprehensive examples
import type { Meta, StoryObj } from '@storybook/angular';
import { action } from '@storybook/addon-actions';

// Full implementation of stories for documentation and testing
export const Default: Story = {
  args: {
    config: {
      multiple: true,
      maxFileSize: 50 * 1024 * 1024, // 50MB
      maxFiles: 10,
      accept: '.pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.txt,.csv,.jpg,.jpeg,.png,.gif'
    },
    disabled: false,
    value: [],
  }
};

// Additional story variations for different use cases
```

### Benefits of Storybook Integration
- **Component Documentation**: Visual documentation of all custom components
- **Development Environment**: Isolated component development and testing
- **Accessibility Testing**: Built-in a11y addon for WCAG compliance verification
- **Design System**: Central place for component library documentation
- **Component Testing**: Interactive testing of component states and props

---

## 🎨 Enhanced Angular Components

### Advanced List Component with Search and Pagination
```typescript
@Component({
  selector: 'app-inventory-list',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    VxTableComponent,
    VxSearchComponent,
    VxPaginationComponent,
    VxButtonComponent
  ],
  template: `
    <div class="inventory-list">
      <div class="header">
        <h2>Inventory Items</h2>
        <vx-button (click)="createItem()" variant="primary">
          Add Item
        </vx-button>
      </div>
      
      <vx-search 
        [(value)]="searchTerm"
        (search)="onSearch($event)"
        placeholder="Search inventory items...">
      </vx-search>
      
      <vx-table 
        [data]="items$ | async"
        [columns]="columns"
        [loading]="loading$ | async"
        (rowClick)="editItem($event)">
      </vx-table>
      
      <vx-pagination
        [totalItems]="totalCount$ | async"
        [currentPage]="currentPage"
        [pageSize]="pageSize"
        (pageChanged)="onPageChange($event)">
      </vx-pagination>
    </div>
  `
})
export class InventoryListComponent implements OnInit {
  items$ = this.inventoryService.items$;
  loading$ = this.inventoryService.loading$;
  totalCount$ = this.inventoryService.totalCount$;
  
  searchTerm = '';
  currentPage = 1;
  pageSize = 20;
  
  columns: TableColumn[] = [
    { key: 'id', label: 'ID', sortable: true },
    { key: 'name', label: 'Name', sortable: true },
    { key: 'description', label: 'Description' },
    { key: 'quantity', label: 'Quantity', sortable: true },
    { key: 'createdDate', label: 'Created', type: 'date', sortable: true }
  ];
  
  constructor(
    private inventoryService: InventoryService,
    private router: Router
  ) {}
  
  ngOnInit(): void {
    this.loadItems();
  }
  
  onSearch(term: string): void {
    this.searchTerm = term;
    this.currentPage = 1;
    this.loadItems();
  }
  
  onPageChange(page: number): void {
    this.currentPage = page;
    this.loadItems();
  }
  
  editItem(item: InventoryItem): void {
    this.router.navigate(['/inventory', item.id, 'edit']);
  }
  
  createItem(): void {
    this.router.navigate(['/inventory', 'create']);
  }
  
  private loadItems(): void {
    this.inventoryService.loadItems({
      searchTerm: this.searchTerm,
      page: this.currentPage,
      pageSize: this.pageSize
    });
  }
}
```

### Enhanced Form Component with Advanced Validation
```typescript
@Component({
  selector: 'app-inventory-form',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    VxFormFieldComponent,
    VxInputComponent,
    VxTextareaComponent,
    VxButtonComponent,
    VxNumberInputComponent
  ],
  template: `
    <form [formGroup]="inventoryForm" (ngSubmit)="onSubmit()">
      <div class="form-header">
        <h2>{{ isEdit ? 'Edit' : 'Create' }} Inventory Item</h2>
      </div>
      
      <vx-form-field label="Name" [required]="true">
        <vx-input 
          formControlName="name"
          placeholder="Enter item name"
          [error]="getFieldError('name')">
        </vx-input>
      </vx-form-field>
      
      <vx-form-field label="Description">
        <vx-textarea 
          formControlName="description"
          placeholder="Enter item description"
          [error]="getFieldError('description')">
        </vx-textarea>
      </vx-form-field>
      
      <vx-form-field label="Quantity" [required]="true">
        <vx-number-input 
          formControlName="quantity"
          [min]="0"
          [error]="getFieldError('quantity')">
        </vx-number-input>
      </vx-form-field>
      
      <div class="form-actions">
        <vx-button type="button" variant="secondary" (click)="cancel()">
          Cancel
        </vx-button>
        <vx-button 
          type="submit" 
          variant="primary"
          [disabled]="inventoryForm.invalid || submitting"
          [loading]="submitting">
          {{ isEdit ? 'Update' : 'Create' }}
        </vx-button>
      </div>
    </form>
  `
})
export class InventoryFormComponent implements OnInit {
  @Input() itemId?: number;
  
  inventoryForm = this.fb.group({
    name: ['', [Validators.required, Validators.maxLength(100)]],
    description: ['', [Validators.maxLength(500)]],
    quantity: [0, [Validators.required, Validators.min(0)]]
  });
  
  submitting = false;
  isEdit = false;
  
  constructor(
    private fb: FormBuilder,
    private inventoryService: InventoryService,
    private router: Router,
    private route: ActivatedRoute
  ) {}
  
  ngOnInit(): void {
    this.itemId = Number(this.route.snapshot.paramMap.get('id'));
    this.isEdit = !!this.itemId;
    
    if (this.isEdit) {
      this.loadItem();
    }
  }
  
  async onSubmit(): Promise<void> {
    if (this.inventoryForm.invalid) return;
    
    this.submitting = true;
    
    try {
      const formValue = this.inventoryForm.value;
      
      if (this.isEdit) {
        await this.inventoryService.updateItem(this.itemId!, {
          id: this.itemId!,
          name: formValue.name!,
          description: formValue.description || '',
          quantity: formValue.quantity!
        });
      } else {
        await this.inventoryService.createItem({
          name: formValue.name!,
          description: formValue.description || '',
          quantity: formValue.quantity!
        });
      }
      
      this.router.navigate(['/inventory']);
    } catch (error) {
      console.error('Failed to save inventory item:', error);
      // Handle error (show notification, etc.)
    } finally {
      this.submitting = false;
    }
  }
  
  cancel(): void {
    this.router.navigate(['/inventory']);
  }
  
  getFieldError(fieldName: string): string | null {
    const field = this.inventoryForm.get(fieldName);
    if (field?.errors && field.touched) {
      if (field.errors['required']) return `${fieldName} is required`;
      if (field.errors['maxlength']) return `${fieldName} is too long`;
      if (field.errors['min']) return `${fieldName} must be positive`;
    }
    return null;
  }
  
  private async loadItem(): Promise<void> {
    try {
      const item = await this.inventoryService.getItem(this.itemId!);
      this.inventoryForm.patchValue({
        name: item.name,
        description: item.description,
        quantity: item.quantity
      });
    } catch (error) {
      console.error('Failed to load inventory item:', error);
      this.router.navigate(['/inventory']);
    }
  }
}
```

---

## 🔗 Enhanced Service Patterns

### Advanced State Management Service
```typescript
@Injectable({
  providedIn: 'root'
})
export class InventoryService {
  private baseUrl = `${this.config.bffApiUrl}/inventory`;
  
  // State subjects
  private itemsSubject = new BehaviorSubject<InventoryItem[]>([]);
  private loadingSubject = new BehaviorSubject<boolean>(false);
  private totalCountSubject = new BehaviorSubject<number>(0);
  private errorSubject = new BehaviorSubject<string | null>(null);
  
  // Public observables
  items$ = this.itemsSubject.asObservable();
  loading$ = this.loadingSubject.asObservable();
  totalCount$ = this.totalCountSubject.asObservable();
  error$ = this.errorSubject.asObservable();
  
  constructor(
    private http: HttpClient,
    private config: ConfigService
  ) {}
  
  loadItems(params: InventorySearchParams): void {
    this.loadingSubject.next(true);
    this.errorSubject.next(null);
    
    const httpParams = new HttpParams()
      .set('page', params.page.toString())
      .set('pageSize', params.pageSize.toString())
      .set('searchTerm', params.searchTerm || '');
    
    this.http.get<PagedResult<InventoryItem>>(`${this.baseUrl}`, { params: httpParams })
      .pipe(
        finalize(() => this.loadingSubject.next(false))
      )
      .subscribe({
        next: (result) => {
          this.itemsSubject.next(result.items);
          this.totalCountSubject.next(result.totalCount);
        },
        error: (error) => {
          console.error('Failed to load inventory items:', error);
          this.errorSubject.next('Failed to load inventory items');
          this.itemsSubject.next([]);
          this.totalCountSubject.next(0);
        }
      });
  }
  
  async getItem(id: number): Promise<InventoryItem> {
    return firstValueFrom(this.http.get<InventoryItem>(`${this.baseUrl}/${id}`));
  }
  
  async createItem(item: CreateInventoryItem): Promise<InventoryItem> {
    return firstValueFrom(this.http.post<InventoryItem>(this.baseUrl, item));
  }
  
  async updateItem(id: number, item: UpdateInventoryItem): Promise<InventoryItem> {
    return firstValueFrom(this.http.put<InventoryItem>(`${this.baseUrl}/${id}`, item));
  }
  
  async deleteItem(id: number): Promise<void> {
    return firstValueFrom(this.http.delete<void>(`${this.baseUrl}/${id}`));
  }
}
```

### Refit Interface for API Communication
```csharp
public interface IInventoryCoreApi
{
    [Get("/api/inventory")]
    Task<PagedResult<InventoryItem>> GetInventoryItemsAsync(
        [Query] string? searchTerm = null,
        [Query] int page = 1,
        [Query] int pageSize = 20);
    
    [Get("/api/inventory/{id}")]
    Task<InventoryItem> GetInventoryItemAsync(int id);
    
    [Post("/api/inventory")]
    Task<InventoryItem> CreateInventoryItemAsync([Body] CreateInventoryItemCommand command);
    
    [Put("/api/inventory/{id}")]
    Task<InventoryItem> UpdateInventoryItemAsync(int id, [Body] UpdateInventoryItemCommand command);
    
    [Delete("/api/inventory/{id}")]
    Task DeleteInventoryItemAsync(int id);
}
```

---

## ✅ Enhanced Validation Patterns

### Custom Angular Validators
```typescript
export class InventoryValidators {
  static uniqueName(inventoryService: InventoryService): AsyncValidatorFn {
    return (control: AbstractControl): Observable<ValidationErrors | null> => {
      if (!control.value) return of(null);
      
      return inventoryService.checkNameExists(control.value).pipe(
        map(exists => exists ? { uniqueName: true } : null),
        catchError(() => of(null))
      );
    };
  }
  
  static minimumQuantity(min: number): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
      if (control.value < min) {
        return { minimumQuantity: { min, actual: control.value } };
      }
      return null;
    };
  }
}
```

### Enhanced FluentValidation with Database Checks
```csharp
public class CreateInventoryItemCommandValidator : AbstractValidator<CreateInventoryItemCommand>
{
    private readonly IInventoryRepository _repository;
    
    public CreateInventoryItemCommandValidator(IInventoryRepository repository)
    {
        _repository = repository;
        
        RuleFor(x => x.Name)
            .NotEmpty()
            .WithMessage("Name is required")
            .MaximumLength(100)
            .WithMessage("Name cannot exceed 100 characters")
            .MustAsync(BeUniqueName)
            .WithMessage("Name must be unique");
            
        RuleFor(x => x.Description)
            .MaximumLength(500)
            .WithMessage("Description cannot exceed 500 characters");
            
        RuleFor(x => x.Quantity)
            .GreaterThanOrEqualTo(0)
            .WithMessage("Quantity must be non-negative");
    }
    
    private async Task<bool> BeUniqueName(string name, CancellationToken cancellationToken)
    {
        var exists = await _repository.ExistsWithNameAsync(name);
        return !exists;
    }
}
```

---

## 🔄 Event-Driven Enhancements

### Domain Events
```csharp
public record InventoryItemCreatedEvent(int ItemId, string Name) : INotification;

public class InventoryItemCreatedEventHandler : INotificationHandler<InventoryItemCreatedEvent>
{
    private readonly IEventPublisher _eventPublisher;
    
    public async Task Handle(InventoryItemCreatedEvent notification, CancellationToken cancellationToken)
    {
        // Publish integration event
        await _eventPublisher.PublishAsync(new InventoryItemCreatedIntegrationEvent
        {
            ItemId = notification.ItemId,
            Name = notification.Name,
            CreatedAt = DateTime.UtcNow
        });
    }
}
```

---

## 🧪 Enhanced Testing Patterns

### Repository Testing with In-Memory Database
```csharp
public class InventoryRepositoryTests : IDisposable
{
    private readonly InventoryDbContext _context;
    private readonly InventoryRepository _repository;
    
    public InventoryRepositoryTests()
    {
        var options = new DbContextOptionsBuilder<InventoryDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
            
        _context = new InventoryDbContext(options);
        _repository = new InventoryRepository(_context);
    }
    
    [Fact]
    public async Task CreateAsync_ValidItem_ReturnsSuccessResult()
    {
        // Arrange
        var item = new InventoryItemEntity
        {
            Name = "Test Item",
            Description = "Test Description",
            Quantity = 10
        };
        
        // Act
        var result = await _repository.CreateAsync(item);
        
        // Assert
        result.Success.Should().BeTrue();
        result.Data.Id.Should().BeGreaterThan(0);
    }
    
    public void Dispose()
    {
        _context.Dispose();
    }
}
```

### Angular Component Testing with Harnesses
```typescript
describe('InventoryListComponent', () => {
  let component: InventoryListComponent;
  let fixture: ComponentFixture<InventoryListComponent>;
  let inventoryService: jasmine.SpyObj<InventoryService>;

  beforeEach(async () => {
    const spy = jasmine.createSpyObj('InventoryService', ['loadItems', 'getItem']);
    
    await TestBed.configureTestingModule({
      imports: [InventoryListComponent],
      providers: [
        { provide: InventoryService, useValue: spy }
      ]
    }).compileComponents();
    
    fixture = TestBed.createComponent(InventoryListComponent);
    component = fixture.componentInstance;
    inventoryService = TestBed.inject(InventoryService) as jasmine.SpyObj<InventoryService>;
  });

  it('should display items when loaded', () => {
    const mockItems = [
      { id: 1, name: 'Item 1', description: 'Desc 1', quantity: 10 },
      { id: 2, name: 'Item 2', description: 'Desc 2', quantity: 20 }
    ];
    
    component.items$ = of(mockItems);
    fixture.detectChanges();
    
    const tableRows = fixture.debugElement.queryAll(By.css('tr[data-test="inventory-row"]'));
    expect(tableRows.length).toBe(2);
  });
});
```

---

## 🔐 Security Enhancements

### Enhanced Authorization
```csharp
[ApiController]
[Route("[controller]")]
[Authorize(Policy = "InventoryAccess")]
public class InventoryController : VertexControllerBase
{
    [HttpPost]
    [Authorize(Policy = "InventoryCreate")]
    public async Task<ActionResult<InventoryItem>> CreateInventoryItem(CreateInventoryItemCommand command)
    {
        // Implementation
    }
    
    [HttpDelete("{id}")]
    [Authorize(Policy = "InventoryDelete")]
    public async Task<ActionResult> DeleteInventoryItem(int id)
    {
        // Implementation
    }
}
```

### Request Rate Limiting
```csharp
public class RateLimitingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly IMemoryCache _cache;
    
    public async Task InvokeAsync(HttpContext context)
    {
        var clientId = GetClientId(context);
        var key = $"rate_limit_{clientId}";
        
        if (_cache.TryGetValue(key, out int requestCount))
        {
            if (requestCount >= 100) // 100 requests per minute
            {
                context.Response.StatusCode = 429;
                await context.Response.WriteAsync("Rate limit exceeded");
                return;
            }
            _cache.Set(key, requestCount + 1, TimeSpan.FromMinutes(1));
        }
        else
        {
            _cache.Set(key, 1, TimeSpan.FromMinutes(1));
        }
        
        await _next(context);
    }
}
```

---

## 📈 Monitoring & Observability

### Enhanced Logging
```csharp
public class EnhancedLoggingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<EnhancedLoggingMiddleware> _logger;
    
    public async Task InvokeAsync(HttpContext context)
    {
        var correlationId = Guid.NewGuid().ToString();
        context.Items["CorrelationId"] = correlationId;
        
        using var scope = _logger.BeginScope(new Dictionary<string, object>
        {
            ["CorrelationId"] = correlationId,
            ["RequestPath"] = context.Request.Path,
            ["RequestMethod"] = context.Request.Method
        });
        
        _logger.LogInformation("Request started");
        
        await _next(context);
        
        _logger.LogInformation("Request completed with status {StatusCode}", context.Response.StatusCode);
    }
}
```

---

**Note**: All patterns in this document are recommendations for future implementation. They represent best practices and enhancements that could be added to the Vertex platform but are not currently present in your templates.
