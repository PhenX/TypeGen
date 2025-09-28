namespace TypeGen.Core.SpecGeneration.Builders.Traits;

internal interface ICustomHeaderTrait<TSpecBuilder>
{
    /// <summary>
    /// Indicates type has a custom header (equivalent of TsExportAttribute's CustomHeader).
    /// </summary>
    /// <returns>The current instance of <typeparamref name="TSpecBuilder"/>.</returns>
    TSpecBuilder CustomHeader(string header);
}
