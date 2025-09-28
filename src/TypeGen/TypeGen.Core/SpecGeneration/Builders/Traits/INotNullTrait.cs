namespace TypeGen.Core.SpecGeneration.Builders.Traits;

internal interface INotNullTrait<TSpecBuilder>
{
    /// <summary>
    /// Marks the selected member as not null (equivalent of TsNotNullAttribute).
    /// </summary>
    /// <returns>The current instance of <typeparamref name="TSpecBuilder"/>.</returns>
    TSpecBuilder NotNull();
}