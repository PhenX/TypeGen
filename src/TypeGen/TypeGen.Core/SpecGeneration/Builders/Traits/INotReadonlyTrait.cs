namespace TypeGen.Core.SpecGeneration.Builders.Traits;

internal interface INotReadonlyTrait<TSpecBuilder>
{
    /// <summary>
    /// Marks the selected member as not readonly (equivalent of TsNotReadonlyAttribute).
    /// </summary>
    /// <returns>The current instance of <typeparamref name="TSpecBuilder"/>.</returns>
    TSpecBuilder NotReadonly();
}